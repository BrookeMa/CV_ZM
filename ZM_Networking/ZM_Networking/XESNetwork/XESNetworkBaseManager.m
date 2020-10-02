//
//  XESNetworkBaseManager.m
//  XESNetwork
//
//  Created by 徐强 on 17/6/26.
//  Copyright © 2017年 XES. All rights reserved.
//

#import "XESNetworkBaseManager.h"
#import <pthread/pthread.h>
#import "XESNetworkPrivate.h"
#import "XESNetworkLog.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
static NSUInteger maxRequestCount = 4;

@implementation XESNetworkBaseManager{
    AFHTTPSessionManager *_manager;
    AFJSONResponseSerializer *_jsonResponseSerializer;
    AFXMLParserResponseSerializer *_xmlParserResponseSerialzier;
    NSMutableDictionary<NSNumber *, XESNetworkBaseRequest *> *_requestsRecord;
    NSMutableArray<XESNetworkBaseRequest *> *_requestsRecordArray;
    NSMutableArray<XESNetworkBaseRequest *> *_activityRequestsRecordArray;
    dispatch_queue_t _processingQueue;
    pthread_mutex_t _lock;
    NSIndexSet *_allStatusCodes;
}

+ (XESNetworkBaseManager *)shareManager;{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _requestsRecord = [NSMutableDictionary dictionary];
        _requestsRecordArray = [[NSMutableArray alloc]init];
        _activityRequestsRecordArray = [[NSMutableArray alloc]init];
        _processingQueue = dispatch_queue_create("com.xes.networkbasemanager.processing", DISPATCH_QUEUE_CONCURRENT);
        _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        pthread_mutex_init(&_lock, NULL);
        _manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:nil];
        _manager.completionQueue = _processingQueue;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSSet *set =  [NSSet setWithArray:@[@"application/json",
                                            @"text/html",
                                            @"text/json",
                                            @"text/plain",
                                            @"text/javascript",
                                            @"text/xml",
                                            @"image/*"]];
        _manager.responseSerializer.acceptableContentTypes = set;
    }
    return self;
}
#pragma Mark- 发起请求and取消请求
-(void)sendRequest:(XESNetworkBaseRequest *)request{
    NSParameterAssert(request != nil);
    NSError * __autoreleasing requestSerializaitonError = nil;
    request.requestTask = [self sessionTaskForRequest:request error:&requestSerializaitonError];
    if (requestSerializaitonError) {
        NSLog(@"请求失败");
        return;
    }
    NSAssert(request.requestTask != nil, @"requestTask should not be nil");
    //    if ([request.requestTask respondsToSelector:@selector(priority)]) {
    //        switch (request.requestPriority) {
    //            case XESRequestPriorityHigh:
    //                request.requestTask.priority = NSURLSessionTaskPriorityHigh;
    //                break;
    //            case XESRequestPriorityLow:
    //                request.requestTask.priority = NSURLSessionTaskPriorityLow;
    //                break;
    //            case XESRequestPriorityDefault:
    //            default:
    //                request.requestTask.priority = NSURLSessionTaskPriorityDefault;
    //                break;
    //        }
    //    }
    [XESNetworkLog logWithStartRequest:request];
    [self addRequestToRecord:request];
    //    [self addRequestToRecordArray:request];
    request.startTime = [NSDate date];
    [request.requestTask resume];
}

-(void)cancelRequest:(XESNetworkBaseRequest *)request{
    NSParameterAssert(request != nil);
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

-(void)cancelAllRequests{
    Lock();
    NSArray *allKeys = [_requestsRecord allKeys];
    Unlock();
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            Lock();
            XESNetworkBaseRequest *request = _requestsRecord[key];
            Unlock();
            [request stop];
        }
    }
}

- (NSURLSessionTask *)sessionTaskForRequest:(XESNetworkBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error{
    
    XESRequestMethod method = request.requestMethod;
    NSString *url = request.requestUrl;
    id param = request.requestParams;
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    
    switch (method) {
        case XESRequestMethodGET:
            if (request.downloadSavePath) {
                return [self downloadTaskWithDownloadPath:request.downloadSavePath requestSerializer:requestSerializer URLString:url parameters:param progress:request.downloadProgressBlock error:error];
            } else {
                return [self dataTaskWithHTTPMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:param error:error];
            }
        case XESRequestMethodPOSTFORMDATA:
            //表单上传
            return [self dataTaskWithHTTPMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if (request.requestFormDataArray) {
                    for (XESNetFormData *requetFormata in request.requestFormDataArray) {
                        [formData appendPartWithFileData:requetFormata.data
                                                    name:requetFormata.name
                                                fileName:requetFormata.filename
                                                mimeType:requetFormata.mimeType];
                    }
                }
            } error:error];;
            
        case XESRequestMethodPOST:
            //表单上传
            return [self dataTaskWithHTTPMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:nil error:error];;
        case XESRequestMethodHEAD:
            return [self dataTaskWithHTTPMethod:@"HEAD" requestSerializer:requestSerializer URLString:url parameters:param error:error];
        case XESRequestMethodPUT:
            return [self dataTaskWithHTTPMethod:@"PUT" requestSerializer:requestSerializer URLString:url parameters:param error:error];
        case XESRequestMethodDELETE:
            return [self dataTaskWithHTTPMethod:@"DELETE" requestSerializer:requestSerializer URLString:url parameters:param error:error];
        case XESRequestMethodPATCH:
            return [self dataTaskWithHTTPMethod:@"PATCH" requestSerializer:requestSerializer URLString:url parameters:param error:error];
    }
}

#pragma mark - 生成 AFHTTPRequestSerializer
- (AFHTTPRequestSerializer *)requestSerializerForRequest:(XESNetworkBaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializerType == XESRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType ==XESRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = request.timeoutInterval;
    requestSerializer.allowsCellularAccess = request.allowsCellularAccess;
    
    NSArray<NSString *> *authorizationHeaderFieldArray = request.requestAuthorizationHeaderFieldArray;
    if (authorizationHeaderFieldArray != nil) {
        [requestSerializer setAuthorizationHeaderFieldWithUsername:authorizationHeaderFieldArray.firstObject
                                                          password:authorizationHeaderFieldArray.lastObject];
    }
    
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = request.requestHeaderFieldValueDictionary;
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    return requestSerializer;
}

#pragma mark - 常规请求方法
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                           error:(NSError * _Nullable __autoreleasing *)error {
    return [self dataTaskWithHTTPMethod:method requestSerializer:requestSerializer URLString:URLString parameters:parameters constructingBodyWithBlock:nil error:error];
}


- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                           error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = nil;
    
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        [self handleRequestWithTask:dataTask upLoadProgress:uploadProgress];
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        [self handleRequestWithTask:dataTask downLoadProgress:downloadProgress];
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleRequestResult:dataTask responseObject:responseObject error:error];
    }];
    return dataTask;
}

#pragma mark - 下载
- (NSURLSessionDownloadTask *)downloadTaskWithDownloadPath:(NSString *)downloadPath
                                         requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                                 URLString:(NSString *)URLString
                                                parameters:(id)parameters
                                                  progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                                     error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:parameters error:error];
    
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    
    __block NSURLSessionDownloadTask *downloadTask = nil;
    downloadTask = [_manager downloadTaskWithRequest:urlRequest progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
    } completionHandler:
                    ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                        [self handleRequestResult:downloadTask responseObject:filePath error:error];
                    }];
    
    return downloadTask;
}

#pragma mark - 处理返回结果
- (void)handleRequestWithTask:(NSURLSessionTask *)task upLoadProgress:(NSProgress *)progress{
    Lock();
    XESNetworkBaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    if (request.uploadProgressBlock && progress) {
        request.uploadProgressBlock(progress);
    }
}
- (void)handleRequestWithTask:(NSURLSessionTask *)task downLoadProgress:(NSProgress *)progress{
    Lock();
    XESNetworkBaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    if (request.downloadProgressBlock && progress) {
        request.downloadProgressBlock(progress);
    }
}
- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    Lock();
    XESNetworkBaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    if (!request) {
        NSLog(@"request为空");
        return;
    }
    request.endTime = [NSDate date];
    NSError * __autoreleasing serializationError = nil;
    //  NSError * __autoreleasing validationError = nil;
    NSError *requestError = nil;
    BOOL succeed = NO;
    request.responseObject = responseObject;
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        request.responseData = responseObject;
        request.responseString = [[NSString alloc] initWithData:responseObject encoding:[XESNetworkUtils stringEncodingWithRequest:request]];
        switch (request.responseSerializerType) {
            case XESResponseSerializerTypeHTTP:
                
                break;
            case XESResponseSerializerTypeJSON:
                request.responseObject = [self.jsonResponseSerializer responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                request.responseJSONObject = request.responseObject;
                break;
            case XESResponseSerializerTypeXMLParser:
                request.responseObject = [self.xmlParserResponseSerialzier responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                break;
            default:
                break;
        }
    }
    if (error) {
        succeed = NO;
        requestError = error;
    }else if (serializationError){
        succeed = NO;
        requestError = serializationError;
    }else{
        succeed = YES;
    }
    if (succeed) {
        [self requestDidSucceedWithRequest:request];
    }else{
        [self requestDidFailWithRequest:request error:requestError];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestFromRecord:request];
        //        [self removeRequestFromActivityRecordArray:request];
        [request clearCompletionBlock];
    });
    
}

- (void)requestDidSucceedWithRequest:(XESNetworkBaseRequest *)request {
    [XESNetworkLog logWithSuccessRequest:request];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
    });
}

- (void)requestDidFailWithRequest:(XESNetworkBaseRequest *)request error:(NSError *)error {
    request.error = error;
    NSLog(@"Request %@ failed, status code = %ld, error = %@",
          NSStringFromClass([request class]), (long)request.responseStatusCode, error.localizedDescription);
    [XESNetworkLog logWithFailureRequest:request];
    if ([request.responseObject isKindOfClass:[NSURL class]]) {
        NSURL *url = request.responseObject;
        if (url.isFileURL && [[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            request.responseData = [NSData dataWithContentsOfURL:url];
            request.responseString = [[NSString alloc]initWithData:request.responseData encoding:[XESNetworkUtils stringEncodingWithRequest:request]];
            [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        }
        request.responseObject = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request);
        }
    });
    
}


#pragma mark - 移除Request
-(void)addRequestToActivityRecordArray:(XESNetworkBaseRequest *)request{
    NSLog(@"addRequestToActivityRecordArray : %@", request);
    Lock();
    [_activityRequestsRecordArray addObject:request];
    [request.requestTask resume];
    Unlock();
}

-(void)removeRequestFromActivityRecordArray:(XESNetworkBaseRequest *)request{
    NSLog(@"removeRequestFromActivityRecordArray : %@", request);
    Lock();
    if ([_activityRequestsRecordArray containsObject:request]) {
        [_activityRequestsRecordArray removeObject:request];
    }
    Unlock();
    if (_activityRequestsRecordArray.count < maxRequestCount && _requestsRecordArray.count > 0) {
        Lock();
        XESNetworkBaseRequest *newRequst = [_requestsRecordArray firstObject];
        Unlock();
        [self addRequestToActivityRecordArray:newRequst];
        [self removeRequestFromRecordArray:newRequst];
    }
}

-(void)addRequestToRecordArray:(XESNetworkBaseRequest *)request{
    NSLog(@"addRequestToRecordArray : %@", request);
    Lock();
    [_requestsRecordArray addObject:request];
    Unlock();
    if (_activityRequestsRecordArray.count < maxRequestCount && _requestsRecordArray.count > 0) {
        Lock();
        XESNetworkBaseRequest *newRequst = [_requestsRecordArray firstObject];
        Unlock();
        [self addRequestToActivityRecordArray:newRequst];
        [self removeRequestFromRecordArray:newRequst];
    }
}

-(void)removeRequestFromRecordArray:(XESNetworkBaseRequest *)request{
    NSLog(@"removeRequestFromRecordArray : %@", request);
    Lock();
    if ([_requestsRecordArray containsObject:request]) {
        [_requestsRecordArray removeObject:request];
    }
    Unlock();
}

- (void)addRequestToRecord:(XESNetworkBaseRequest *)request {
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRecord:(XESNetworkBaseRequest *)request {
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    //    NSLog(@"Request queue size = %zd", [_requestsRecord count]);
    Unlock();
}


#pragma mark - Getter
- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        NSSet *set =  [NSSet setWithArray:@[@"application/json",
                                            @"text/html",
                                            @"text/json",
                                            @"text/plain",
                                            @"text/javascript",
                                            @"text/xml",
                                            @"image/*"]];
        _jsonResponseSerializer.acceptableContentTypes = set;
        
    }
    return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlParserResponseSerialzier {
    if (!_xmlParserResponseSerialzier) {
        _xmlParserResponseSerialzier = [AFXMLParserResponseSerializer serializer];
        //        _xmlParserResponseSerialzier.acceptableStatusCodes = _allStatusCodes;
        NSSet *set =  [NSSet setWithArray:@[@"application/json",
                                            @"text/html",
                                            @"text/json",
                                            @"text/plain",
                                            @"text/javascript",
                                            @"text/xml",
                                            @"image/*"]];
        _xmlParserResponseSerialzier.acceptableContentTypes = set;
    }
    return _xmlParserResponseSerialzier;
}
@end


//
//  XESNetworkBaseRequest.m
//  XESNetwork
//
//  Created by 徐强 on 17/6/26.
//  Copyright © 2017年 XES. All rights reserved.
//

#import "XESNetworkBaseRequest.h"
#import "XESNetworkBaseManager.h"

@interface XESNetworkBaseRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) id responseJSONObject;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) NSString *responseString;
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, strong, readwrite) NSDate *startTime;
@property (nonatomic, strong, readwrite) NSDate *endTime;

@end

@implementation XESNetworkBaseRequest

#pragma mark - Life Cycle
-(void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.requestMethod = XESRequestMethodGET;
        self.requestUrl = @"";
        self.requestParams = nil;
        self.requestPriority = XESRequestPriorityDefault;
        self.requestSerializerType = XESRequestSerializerTypeHTTP;
        self.responseSerializerType = XESResponseSerializerTypeJSON;
        self.timeoutInterval = 30;
        self.allowsCellularAccess = YES;
    }
    return self;
}

#pragma mark - Request and Response Information
- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}

- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    return self.requestTask.originalRequest;
}

- (BOOL)isCancelled {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}
#pragma mark -
- (void)setCompletionBlockWithUploadProgess:(nullable XESUpLoadProgress)uploadProgress
                           downLoadProgress:(nullable XESDownLoadProgress)downloadProgress
                                    success:(XESResponseSuccess)success
                                    failure:(XESResponseFail)failure {
    self.uploadProgressBlock = uploadProgress;
    self.downloadProgressBlock = downloadProgress;
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    self.uploadProgressBlock = nil;
    self.downloadProgressBlock = nil;
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}


#pragma mark -
-(void)start{
    [[XESNetworkBaseManager shareManager] sendRequest:self];
}

- (void)stop {
    [[XESNetworkBaseManager shareManager] cancelRequest:self];
}

@end

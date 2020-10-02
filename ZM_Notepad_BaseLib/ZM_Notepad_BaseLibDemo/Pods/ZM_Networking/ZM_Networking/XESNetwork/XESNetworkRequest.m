//
//  XESNetworkRequest.m
//  XESNetwork
//
//  Created by 徐强 on 17/6/28.
//  Copyright © 2017年 XES. All rights reserved.
//

#import "XESNetworkRequest.h"
#import "XESNetworkBaseRequest.h"

@implementation XESNetworkRequest

#pragma mark - 

+(instancetype)requestWithMethodType:(XESRequestMethod)requestMethod
                                        url:(NSString *)requestUrl
                                      param:(id)requestParams{

    return [self networkreqeustWith:requestMethod
                                url:requestUrl
                              param:requestParams
                      formdataArray:nil
                         saveToPath:nil];
}


+(instancetype)formDataRequestWithUrl:(NSString *)requestUrl
                                       param:(id)requestParams
                                    formdata:(XESNetFormData *)formData{
    
    return [self networkreqeustWith:XESRequestMethodPOSTFORMDATA
                                url:requestUrl
                              param:requestParams
                      formdataArray:formData==nil?@[]:@[formData]
                         saveToPath:nil];
}

+(instancetype)formDataRequestWithUrl:(NSString *)requestUrl
                                param:(id)requestParams
                        formdataArray:(NSArray *)formDataArray{
    
    return [self networkreqeustWith:XESRequestMethodPOSTFORMDATA
                                url:requestUrl
                              param:requestParams
                      formdataArray:formDataArray
                         saveToPath:nil];
}


+(instancetype)downLoadRequestWithDownloadUrl:(NSString *)downloadUrl
                                           saveToPath:(NSString *)saveToPath{
    return [self networkreqeustWith:XESRequestMethodGET
                                url:downloadUrl
                              param:nil
                      formdataArray:nil
                         saveToPath:saveToPath];
}

+(XESNetworkRequest *)networkreqeustWith:(XESRequestMethod)requestMethod
                      url:(NSString *)requestUrl
                    param:(id)requestParams
            formdataArray:(NSArray *)formDataArray
               saveToPath:(NSString *)saveToPath{
    
    XESNetworkRequest *request  = [[self alloc] init];
    request.requestMethod       = requestMethod;
    request.requestUrl          = requestUrl;
    request.requestParams       = requestParams;
    request.requestFormDataArray= formDataArray;
    request.downloadSavePath    = saveToPath;
    return request;
}

#pragma mark -

- (void)startWithSuccess:(XESResponseSuccess)success
                 failure:(XESResponseFail)failure{
    [self startWithProgess:nil success:success failure:failure];
}

- (void)startWithProgess:(XESRequestProgress)uploadProgress
                 success:(XESResponseSuccess)success
                 failure:(XESResponseFail)failure{
    [self setCompletionBlockWithUploadProgess:uploadProgress downLoadProgress:nil success:success failure:failure];
    [self start];
}

-(void)uploadWithProgess:(XESUpLoadProgress)uploadProgress
                 success:(XESResponseSuccess)success
                 failure:(XESResponseFail)failure{
    [self setCompletionBlockWithUploadProgess:uploadProgress downLoadProgress:nil success:success failure:failure];
    [self start];
    
}

-(void)downloadWithProgess:(XESDownLoadProgress)downLoadProgress
                   success:(XESResponseSuccess)success
                   failure:(XESResponseFail)failure{
    [self setCompletionBlockWithUploadProgess:nil downLoadProgress:downLoadProgress success:success failure:failure];
    [self start];
    
}
@end

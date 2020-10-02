//
//  XESNetworkRequest.h
//  XESNetwork
//
//  Created by 徐强 on 17/6/28.
//  Copyright © 2017年 XES. All rights reserved.
//

#import "XESNetworkBaseRequest.h"

@interface XESNetworkRequest : XESNetworkBaseRequest

#pragma mark - 初始化

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


/**
 普通请求 基本参数初始化 其他自定义参数可单独设置

 @param requestMethod 请求方法
 @param requestUrl 请求地址
 @param requestParams 请求参数
 @return XESNetworkRequest
 */
+(instancetype)requestWithMethodType:(XESRequestMethod)requestMethod
                                        url:(NSString *)requestUrl
                                      param:(id)requestParams;


/**
 表单上传 基本参数初始化方法 其他自定义参数可单独设置

 @param requestUrl 请求地址
 @param requestParams 请求参数
 @param formData 上传数据
 @return XESNetworkRequest
 */
+(instancetype)formDataRequestWithUrl:(NSString *)requestUrl
                                       param:(id)requestParams
                                    formdata:(XESNetFormData *)formData;


/**
 表单上传 基本参数初始化方法 其他自定义参数可单独设置
 
 @param requestUrl 请求地址
 @param requestParams 请求参数
 @param formdataArray 上传数据
 @return XESNetworkRequest
 */
+(instancetype)formDataRequestWithUrl:(NSString *)requestUrl
                                param:(id)requestParams
                        formdataArray:(NSArray *)formDataArray;


/**
  下载请求 基本参数初始化方法 其他自定义参数可单独设置

 @param downloadUrl 下载地址
 @param saveToPath 下载保存地址
 @return XESNetworkRequest
 */
+(instancetype)downLoadRequestWithDownloadUrl:(NSString *)downloadUrl
                                           saveToPath:(NSString *)saveToPath;


#pragma mark - 方法

/**
 发起一个请求 不带进度回调
 @param success 成功回调
 @param failure 失败回调
 */
- (void)startWithSuccess:(XESResponseSuccess)success
                 failure:(XESResponseFail)failure;

/**
 发起一个带进度回调的请求
 @param uploadProgress 请求进度回调
 @param success 成功回调
 @param failure 失败回调
 */
- (void)startWithProgess:(XESRequestProgress)uploadProgress
                 success:(XESResponseSuccess)success
                 failure:(XESResponseFail)failure;

/**
 下载文件
 @param downLoadProgress 下载进度
 @param success 下载成功回调
 @param failure 下载失败回调
 */
-(void)downloadWithProgess:(XESDownLoadProgress)downLoadProgress
                   success:(XESResponseSuccess)success
                   failure:(XESResponseFail)failure;
@end

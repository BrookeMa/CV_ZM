//
//  XESNetworkBaseRequest.h
//  XESNetwork
//
//  Created by 徐强 on 17/6/26.
//  Copyright © 2017年 XES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XESNetFormData.h"

NS_ASSUME_NONNULL_BEGIN

@class XESNetworkBaseRequest;

typedef NS_ENUM(NSInteger, XESRequestMethod) {
    XESRequestMethodGET = 0,
    XESRequestMethodPOST,
    XESRequestMethodPOSTFORMDATA,
    XESRequestMethodHEAD,
    XESRequestMethodPUT,
    XESRequestMethodDELETE,
    XESRequestMethodPATCH,
};

typedef NS_ENUM(NSInteger, XESRequestSerializerType) {
    XESRequestSerializerTypeHTTP = 0,
    XESRequestSerializerTypeJSON,
};

typedef NS_ENUM(NSInteger, XESResponseSerializerType) {
    XESResponseSerializerTypeHTTP,
    XESResponseSerializerTypeJSON,
    XESResponseSerializerTypeXMLParser,
};

typedef NS_ENUM(NSInteger, XESRequestPriority) {
    XESRequestPriorityLow = -4L,
    XESRequestPriorityDefault = 0,
    XESRequestPriorityHigh = 4,
};

typedef void (^XESURLSessionTaskProgressBlock)(NSProgress *progress);
typedef XESURLSessionTaskProgressBlock XESRequestProgress;///< 请求进度
typedef XESURLSessionTaskProgressBlock XESUpLoadProgress;///< 上传进度
typedef XESURLSessionTaskProgressBlock XESDownLoadProgress;///< 下载请求进度

typedef void(^XESResponseSuccess)(XESNetworkBaseRequest *sucessRequset);///< 成功回调
typedef void(^XESResponseFail)   (XESNetworkBaseRequest *failRequset);///< 失败回调


@interface XESNetworkBaseRequest : NSObject

#pragma mark - 基本请求配置信息
//基本请求设置
@property (nonatomic, copy) NSString *requestName;///< 请求名字
@property (nonatomic, assign) XESRequestMethod       requestMethod;///< 请求类型 默认XESRequestMethodGET
@property (nonatomic, copy) NSString                 *requestUrl;///< 请求地址 默认@""
@property (nonatomic, strong, nullable)id requestParams;///< 请求参数  默认nil

//扩展请求设置
@property (nonatomic, assign) XESRequestPriority requestPriority;///< 请求等级 默认XESRequestPriorityDefault
@property (nonatomic, assign) XESRequestSerializerType requestSerializerType;///<请求序列化类型 默认XESRequestSerializerTypeHTTP
@property (nonatomic, assign) XESResponseSerializerType responseSerializerType;///<回应序列化类型 默认XESResponseSerializerTypeJSON
@property (nonatomic, assign) NSTimeInterval timeoutInterval;///< 超时时间 默认30S
@property (nonatomic, strong) NSArray *requestAuthorizationHeaderFieldArray;///< 请求授权参数
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *requestHeaderFieldValueDictionary;///< 请求头
@property (nonatomic, assign) BOOL allowsCellularAccess;///< 是否允许使用蜂窝连接

//上传下载
@property (nonatomic, strong, nullable) XESNetFormData *requestFormData;///< 上传表单数据
@property (nonatomic, strong, nullable) NSArray *requestFormDataArray;///< 上传表单数据数组
@property (nonatomic, strong, nullable) NSString *downloadSavePath;///< 下载保存地址地址

//请求回调block
@property (nonatomic, copy, nullable) XESResponseSuccess successCompletionBlock;///< 请求成功回调
@property (nonatomic, copy, nullable) XESResponseFail failureCompletionBlock;///< 请求失败回调
@property (nonatomic, copy, nullable) XESUpLoadProgress uploadProgressBlock;///< 上传进度回调
@property (nonatomic, copy, nullable) XESDownLoadProgress downloadProgressBlock;///< 下载进度回调


#pragma mark - 请求和返回信息
@property (nonatomic, strong, readonly) NSURLSessionTask *requestTask;///< NSURLSesionTask
@property (nonatomic, strong, readonly) NSURLRequest     *currentRequest;///< 当前由任务处理的URL请求对象。
@property (nonatomic, strong, readonly) NSURLRequest     *originalRequest;///< 创建任务时传递的原始请求对象
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;///< response信息
@property (nonatomic, readonly)         NSInteger responseStatusCode;///< 返回code
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;///< 返回头
@property (nonatomic, strong, readonly, nullable) NSData *responseData;///< 返回数据NSData
@property (nonatomic, strong, readonly, nullable) NSString *responseString;///< 返回数据转字符串
@property (nonatomic, strong, readonly, nullable) id responseJSONObject;
@property (nonatomic, strong, readonly, nullable) id responseObject;///< 返回数据
@property (nonatomic, strong, readonly, nullable) NSError *error;///< 请求错误信息
@property (nonatomic, readonly, getter=isCancelled) BOOL cancelled;///< 是否取消
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;///< 是否正在进行中
@property (nonatomic, strong, readonly) NSDate *startTime;///< 请求发起时间
@property (nonatomic, strong, readonly) NSDate *endTime;///< 请求结束时间


#pragma mark - 请求接口

/**
 发起请求
 */
- (void)start;

/**
 停止请求
 */
- (void)stop;


/**
 设置回调Block
 
 @param uploadProgress 上传进度回调
 @param downloadProgress 下载进度回调
 @param success 成功回调
 @param failure 失败回调
 */
- (void)setCompletionBlockWithUploadProgess:(nullable XESUpLoadProgress)uploadProgress
                           downLoadProgress:(nullable XESDownLoadProgress)downloadProgress
                                    success:(XESResponseSuccess)success
                                    failure:(XESResponseFail)failure;
NS_ASSUME_NONNULL_END
@end


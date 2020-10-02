//
//  XESNetworkPrivate.h
//  XESNetwork
//
//  Created by 徐强 on 17/6/27.
//  Copyright © 2017年 XES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XESNetworkBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface XESNetworkUtils : NSObject

+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator;

+ (void)addDoNotBackupAttribute:(NSString *)path;

/**
 MD5字符串加密

 @param string 需要加密字符串
 @return 加密后字符串
 */
+ (NSString *)md5StringFromString:(NSString *)string;


/**
 获取APP版本字符串

 @return APP版本
 */
+ (NSString *)appVersionString;


/**
 获取NSencoding

 @param request XESNetworkBaseRequest
 @return NSStringEncoding
 */
+ (NSStringEncoding)stringEncodingWithRequest:(XESNetworkBaseRequest *)request;


+ (BOOL)validateResumeData:(NSData *)data;

@end


@interface XESNetworkBaseRequest (Setter)

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;
@property (nonatomic, strong, readwrite, nullable) id responseJSONObject;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;
@property (nonatomic, strong, readwrite) NSDate *startTime;
@property (nonatomic, strong, readwrite) NSDate *endTime;

@end

@interface XESNetworkBaseRequest(Private)
/**
 清除block
 */
- (void)clearCompletionBlock;

@end

@interface XESNetworkPrivate : NSObject

@end

NS_ASSUME_NONNULL_END

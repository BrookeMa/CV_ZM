//
//  XESNetworkLog.h
//  XESNetworkDemo
//
//  Created by 徐强 on 17/7/11.
//  Copyright © 2017年 XES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XESNetworkBaseRequest.h"

@interface XESNetworkLog : NSObject

/**
 发起请求Log

 @param request XESNetworkBaseRequest
 @return log信息
 */
+ (NSString *)logWithStartRequest:(XESNetworkBaseRequest *)request;


/**
 请求成功Log

 @param request XESNetworkBaseRequest
 @return log信息
 */
+ (NSString *)logWithSuccessRequest:(XESNetworkBaseRequest *)request;


/**
 请求失败Log

 @param request XESNetworkBaseRequest
 @return log信息
 */
+ (NSString *)logWithFailureRequest:(XESNetworkBaseRequest *)request;
@end

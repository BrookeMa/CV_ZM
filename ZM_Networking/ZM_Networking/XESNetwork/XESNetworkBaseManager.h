//
//  XESNetworkBaseManager.h
//  XESNetwork
//
//  Created by 徐强 on 17/6/26.
//  Copyright © 2017年 XES. All rights reserved.
//
/******************************************
        XESNetwork请求base类
 ******************************************/


#import <Foundation/Foundation.h>
#import "XESNetworkBaseRequest.h"

@interface XESNetworkBaseManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 获取单例对象
 
 @return XESNetworkBaseManager
 */
+ (XESNetworkBaseManager *)shareManager;


/**
 发起一个request请求
 
 @param request XESNetworkBaseRequest
 */
-(void)sendRequest:(XESNetworkBaseRequest *)request;


/**
 取消某个Request

 @param request 要取消的request
 */
- (void)cancelRequest:(XESNetworkBaseRequest *)request;


/**
 取消所有请求
 */
- (void)cancelAllRequests;

@end

//
//  ZMNNetworkRequest.h
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/30.
//

#import <Foundation/Foundation.h>
#import <ZM_Networking/XESNetworkRequest.h>

@interface ZMNNetworkRequest : XESNetworkRequest


+ (instancetype)requestWithMethodType:(XESRequestMethod)requestMethod
                                  url:(NSString *)requestUrl
                                param:(id)requestParams
                          withMetaDic:(NSDictionary *)metaDic;


@end

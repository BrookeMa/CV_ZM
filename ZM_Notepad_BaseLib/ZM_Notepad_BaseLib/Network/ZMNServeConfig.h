//
//  ZMNServeConfig.h
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/30.
//

#import <Foundation/Foundation.h>
#import "ZMNConstantsManager.h"

#define ZMNServeConfigInstance [ZMNServeConfig sharedInstance]

@interface ZMNServeConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)sharedInstance;

/**
 配置拼接URL方法
 
 @param parameter URl地址参数 不需要传Host,内部拼接host
 @return 完整URL
 */
- (NSString *)getNormalRequestUrl:(NSString *)parameter;


@end

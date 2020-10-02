//
//  ZMThirdLoginManager.h
//  Pods-ZM_UMComponentDemo
//
//  Created by Ye Ma on 2018/8/31.
//

#import <Foundation/Foundation.h>

@interface ZMThirdLoginManager : NSObject

+ (instancetype)sharedInstance;
/**
 微信登录
 */
- (void)loginFromWechatWithVC:(__kindof UIViewController *)vc
                      success:(void (^)(NSString *wx_unionid, NSString *avatar))success
                         fail:(void (^)(NSError *error))fail;
/**
 QQ登录
 */
- (void)loginFromQQWithVC:(__kindof UIViewController *)vc
                  success:(void (^)(NSString *qq_openid, NSString *avatar))success
                     fail:(void (^)(NSError *error))fail;

/**
 是否安装微信

 @return 是否安装微信
 */
- (BOOL)isInstalledWechat;

/**
 是否安装QQ
 
 @return 是否安装QQ
 */
- (BOOL)isInstalledQQ;
@end

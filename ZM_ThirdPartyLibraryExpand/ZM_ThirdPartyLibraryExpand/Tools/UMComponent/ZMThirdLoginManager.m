//
//  ZMThirdLoginManager.m
//  Pods-ZM_UMComponentDemo
//
//  Created by Ye Ma on 2018/8/31.
//

#import "ZMThirdLoginManager.h"
#import <UMShare/UMShare.h>

@implementation ZMThirdLoginManager

+ (instancetype)sharedInstance
{
    __strong static ZMThirdLoginManager * _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

/**
 微信登录
 */
- (void)loginFromWechatWithVC:(__kindof UIViewController *)vc
                      success:(void (^)(NSString *wx_unionid, NSString *avatar))success
                              fail:(void (^)(NSError *error))fail {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:vc completion:^(id result, NSError *error) {
        if (error) {
            fail(error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            success(resp.unionId, resp.iconurl);
        }
    }];
}

/**
 QQ登录
 */
- (void)loginFromQQWithVC:(__kindof UIViewController *)vc
              success:(void (^)(NSString *qq_openid, NSString *avatar))success
                              fail:(void (^)(NSError *error))fail {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:vc completion:^(id result, NSError *error) {
        if (error) {
            fail(error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            success(resp.openid, resp.iconurl);
        }
    }];
}

- (BOOL)isInstalledWechat {
    return [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession];
}

- (BOOL)isInstalledQQ {
    return [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ];
}
@end

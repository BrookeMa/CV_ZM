//
//  ZMNUserInfo.m
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/31.
//

#import "ZMNUserInfo.h"
#import "ZMKeyChainManager.h"
#import <objc/runtime.h>

@implementation ZMNUserInfo

+ (instancetype)sharedInstance
{
    static ZMNUserInfo * _userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[self alloc] init];
    });
    return _userInfo;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)LoginState
{
    if ([self.token isEqualToString:@"-1"] &&
        [self.uid isEqualToString:@"-1"]) {
        return NO;
    }
    return YES;
}

- (void)setUid:(NSString *)uid {
    [[ZMKeyChainManager shareInstance] setUid:uid];
}

- (void)setToken:(NSString *)token {
    [[ZMKeyChainManager shareInstance] setToken:token];
}

- (NSString *)uid {
    return [[ZMKeyChainManager shareInstance] getUid];
}

- (NSString *)token {
    return [[ZMKeyChainManager shareInstance] getToken];
}

@end

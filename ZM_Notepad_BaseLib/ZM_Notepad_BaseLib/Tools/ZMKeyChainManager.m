//
//  ZMKeyChainManager.m
//  ZM_Notepad_BaseLib
//
//  Created by Ye Ma on 2018/9/13.
//

#import "ZMKeyChainManager.h"
#import "UICKeyChainStore.h"

@interface ZMKeyChainManager()

@property (nonatomic, strong) UICKeyChainStore *keychain;

@end

@implementation ZMKeyChainManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.keychain = [UICKeyChainStore keyChainStoreWithService:@"com.shzhanmeng.notpad"];
    }
    return self;
}

+ (instancetype)shareInstance
{
    static ZMKeyChainManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)setToken:(NSString *)token {
    self.keychain[@"shzhanmengtoken"] = token;
}

- (void)setUid:(NSString *)uid {
    self.keychain[@"shzhanmenguid"] = uid;
}

- (NSString *)getToken {
    NSError *error;
    NSString * token = [self.keychain stringForKey:@"shzhanmengtoken" error:&error];
    if (error) {
        NSLog(@"getToken %@", error.localizedDescription);
    }
    if (token) {
        return token;
    }
    return @"-1";
}

- (NSString *)getUid {
    NSError *error;
    NSString * uid = [self.keychain stringForKey:@"shzhanmenguid" error:&error];
    if (error) {
        NSLog(@"getUid %@", error.localizedDescription);
    }
    if (uid) {
        return uid;
    }
    return @"-1";
}

@end

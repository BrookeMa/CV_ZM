//
//  ZMKeyChainManager.h
//  ZM_Notepad_BaseLib
//
//  Created by Ye Ma on 2018/9/13.
//

#import <Foundation/Foundation.h>

@interface ZMKeyChainManager : NSObject

+ (instancetype)shareInstance;

- (void)setToken:(NSString *)token;
- (void)setUid:(NSString *)uid;
- (NSString *)getToken;
- (NSString *)getUid;

@end

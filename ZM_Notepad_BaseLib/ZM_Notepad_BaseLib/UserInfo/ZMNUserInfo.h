//
//  ZMNUserInfo.h
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/31.
//

#import <Foundation/Foundation.h>


#define ZMNUserInfoInstance [ZMNUserInfo sharedInstance]

@interface ZMNUserInfo : NSObject

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * uid;

+ (instancetype)sharedInstance;

- (BOOL)LoginState;

@end

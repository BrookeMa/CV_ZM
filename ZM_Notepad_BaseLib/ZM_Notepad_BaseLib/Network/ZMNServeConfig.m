//
//  ZMNServeConfig.m
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/30.
//

#import "ZMNServeConfig.h"

@interface ZMNServeConfig()


@end


@implementation ZMNServeConfig

+ (instancetype)sharedInstance
{
    static ZMNServeConfig * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (NSString *)getNormalRequestUrl:(NSString *)parameter
{
    if (parameter) {
        return [NSString stringWithFormat:@"%@%@",ZMNConstantsManagerInstance.baseUrl,parameter];
    }
    NSAssert(parameter, @"参数不能为空！");
    return ZMNConstantsManagerInstance.baseUrl;
}

@end

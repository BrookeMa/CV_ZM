//
//  ZMNConstantsManager.m
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/30.
//

#import "ZMNConstantsManager.h"

@implementation ZMNConstantsManager

+ (instancetype)sharedInstance
{
    static ZMNConstantsManager * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance constantDefaultSet];
    });
    return _instance;
}

- (void)constantDefaultSet
{
    self.isOpenUMeng = NO;
    self.networkEnvironmentType = ZMNNetWorkEnvironmentTypeDevelop;
}

- (void)resetBaseUrlByNetworkEnvironmentType
{
    switch (self.networkEnvironmentType) {
        case ZMNNetWorkEnvironmentTypeDevelop:
        {
            self.baseUrl = @"http://beta-api.heinote.com/api/";
        }
            break;
        case ZMNNetWorkEnvironmentTypeDistribution:
        {
            self.baseUrl = @"http://beta-api.heinote.com/api/";
        }
            break;
        default:
        {
            self.baseUrl = @"http://beta-api.heinote.com/api/";
        }
            break;
    }
}

- (void)setNetworkEnvironmentType:(ZMNNetWorkEnvironmentType)networkEnvironmentType
{
    _networkEnvironmentType = networkEnvironmentType;
    [self resetBaseUrlByNetworkEnvironmentType];
}

@end

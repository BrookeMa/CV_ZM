//
//  ZMNetworkInfo.h
//  ZM_BaseLib
//
//  Created by Chin on 2018/8/9.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ZMNetworkType)
{
    ZMNetworkType_Unknown        = -1,
    ZMNetworkType_None           = 0,
    ZMNetworkType_WiFi           = 1,
    ZMNetworkType_2G             = 2,
    ZMNetworkType_3G             = 3,
    ZMNetworkType_4G             = 4,
};


static NSString * kZMChangedNotification = @"ZMNetworkEnvironment_Changed";

@interface ZMNetworkInfo : NSObject

/**
 网络状态
 */
@property (assign, nonatomic) ZMNetworkType networkType;

+ (instancetype)sharedInstance;

@end

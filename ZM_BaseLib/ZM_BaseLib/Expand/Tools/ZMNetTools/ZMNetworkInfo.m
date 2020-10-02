//
//  ZMNetworkInfo.m
//  ZM_BaseLib
//
//  Created by Chin on 2018/8/9.
//

#import "ZMNetworkInfo.h"
#import "ZMReachability.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface ZMNetworkInfo()

@property (strong, nonatomic) CTTelephonyNetworkInfo * netinfo;
@property (strong, nonatomic) ZMReachability * reachAbility;
@property (assign, nonatomic) ZMNetworkStatus networkStatus;

@end


@implementation ZMNetworkInfo

+ (instancetype)sharedInstance
{
    static ZMNetworkInfo * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [ZMNetworkInfo new];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.netinfo      = [[CTTelephonyNetworkInfo alloc] init];
        self.reachAbility = [ZMReachability reachabilityForInternetConnection];
        [self.reachAbility startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kZMReachabilityChangedNotification object:nil];
    }
    return self;
}

- (ZMNetworkType)networkType
{
    if (self.networkStatus == ZMReachableViaWiFi) {
        return ZMNetworkType_WiFi;  //WIFI
    }else if (self.networkStatus == ZMNotReachable) {
        return ZMNetworkType_None;
    }else{
        NSString * currentStatus  = self.netinfo.currentRadioAccessTechnology; //获取当前网络描述
        NSArray  * type2G = @[CTRadioAccessTechnologyEdge,
                              CTRadioAccessTechnologyGPRS,
                              CTRadioAccessTechnologyCDMA1x];
        
        NSArray  * type3G = @[CTRadioAccessTechnologyHSDPA,
                              CTRadioAccessTechnologyWCDMA,
                              CTRadioAccessTechnologyHSUPA,
                              CTRadioAccessTechnologyCDMAEVDORev0,
                              CTRadioAccessTechnologyCDMAEVDORevA,
                              CTRadioAccessTechnologyCDMAEVDORevB,
                              CTRadioAccessTechnologyeHRPD];
        
        NSArray  * type4G = @[CTRadioAccessTechnologyLTE];
        
        if ([type2G containsObject:currentStatus]) {
            return ZMNetworkType_2G;
        }else if ([type3G containsObject:currentStatus]) {
            return ZMNetworkType_3G;
        }else if ([type4G containsObject:currentStatus]) {
            return ZMNetworkType_4G;
        }else {
            return ZMNetworkType_Unknown;
        }
    }
}

- (void)reachabilityChanged:(NSNotification *)info
{
    ZMReachability * curReach = [info object];
    if (![curReach isKindOfClass:[ZMReachability class]]) {
        return;
    }
    ZMNetworkStatus status = [curReach currentReachabilityStatus];
    self.networkStatus = status;
    if (self.networkStatus == ZMReachableViaWiFi){
        NSLog(@"网络状态为:WiFi");
    }else if (self.networkStatus == ZMReachableViaWWAN){
        NSLog(@"网络状态为:2G/3G/4G/5G");
    }else{
        NSLog(@"网络状态为:无网络");
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kZMChangedNotification object:nil];
    
}

@end

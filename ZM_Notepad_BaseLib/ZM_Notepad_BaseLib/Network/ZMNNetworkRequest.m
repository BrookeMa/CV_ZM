//
//  ZMNNetworkRequest.m
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/30.
//

#import "ZMNNetworkRequest.h"
#import <ZM_BaseLib/ZMSystemGlobal.h>


@interface ZMNNetworkRequest()

@property (nonatomic, strong) NSMutableDictionary * meta;
@property (nonatomic, assign) NSInteger lastRequestTimeMs; ///<上次请求时间
@property (nonatomic, assign) NSInteger currentRequestTimeMs;///<本次请求时间


@end

@implementation ZMNNetworkRequest

+ (instancetype)requestWithMethodType:(XESRequestMethod)requestMethod
                                  url:(NSString *)requestUrl
                                param:(id)requestParams
                          withMetaDic:(NSDictionary *)metaDic
{
    NSDictionary * zmnDic = @{@"meta":[self configureMetaWithmetaDic:metaDic],@"data":requestParams};
    return [super requestWithMethodType:requestMethod url:requestUrl param:zmnDic];
}

+ (NSDictionary *)configureMetaWithmetaDic:(NSDictionary *)metaDic
{
    
    NSInteger currentRequestTimeMs = [NSDate new].timeIntervalSince1970 * 1000;
    static NSInteger lastRequestTimeMs = 0;
    if (lastRequestTimeMs == 0) {
        lastRequestTimeMs = currentRequestTimeMs;
    }
    NSString * last = [NSString stringWithFormat:@"%ld", lastRequestTimeMs];
    NSString * current = [NSString stringWithFormat:@"%ld",currentRequestTimeMs];
    NSString * build = [ZMSystemGlobal sharedInstance].build;
    NSString * version = [ZMSystemGlobal sharedInstance].version;
    NSString * uuid = [ZMSystemGlobal sharedInstance].uuid;
    NSString * ac = [ZMSystemGlobal sharedInstance].ac;
    
    NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithCapacity:10];
    [newDic addEntriesFromDictionary:metaDic];
    NSDictionary * dic = @{@"last_req_time_ms":last,
                           @"current_req_time_ms":current,
                           @"platform":@"iOS",
                           @"device_platform":@"iOS",
                           @"version_code":build,
                           @"version_name":version,
                           @"uuid":uuid,
                           @"ac":ac
                           };
    [newDic addEntriesFromDictionary:dic];
    
    return newDic;
}

@end

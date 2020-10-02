//
//  ZMRouterPath.m
//  ZM_ThirdPartyLibraryExpand
//
//  Created by Chin on 2018/8/1.
//

#import "ZMRouterPath.h"
#import "ZMRouterModel.h"
#import "NSObject+YYModel.h"

@implementation ZMRouterPath

+ (instancetype)sharedInstance
{
    static ZMRouterPath * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.configName = @"ZMRouter";
    }
    return self;
}

- (NSArray<ZMRouterModel *> *)getRouterList
{
    NSArray<ZMRouterModel *> * modelArray = [self getRouterListWithPlistName:self.configName];
    return modelArray;
}

- (NSArray<ZMRouterModel *> *)getRouterListWithPlistName:(NSString *)plistName
{
    NSDictionary * configDic = [self getPathFromName:plistName];
    NSArray<NSString *> * allKeys= configDic.allKeys;
    NSMutableArray<ZMRouterModel *> * modelArray = [NSMutableArray arrayWithCapacity:10];
    for (NSString * key in allKeys) {
        NSDictionary * obj  = configDic[key];
        NSArray * objAllKeys= obj.allKeys;
        for (NSString * objKey in objAllKeys) {
            NSDictionary * urlDic = obj[objKey];
            ZMRouterModel * model = [ZMRouterModel modelWithDictionary:urlDic];
            [modelArray addObject:model];
        }
    }
    return modelArray;
}

- (NSDictionary *)getPathFromName:(NSString *)name
{
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    return [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

- (ZMRouterModel *)pathRouterModel:(NSString *)key{
    NSDictionary * pathDictionary = [self getPathFromName:self.configName];
    NSDictionary * dic  = pathDictionary[@"ReleaseURL"];
    NSArray *dicAllKeys = [dic allKeys];
    ZMRouterModel * model = nil;
    for (NSString * urlKey in dicAllKeys) {
        NSDictionary * urlDic = dic[urlKey];
        model = [ZMRouterModel modelWithDictionary:urlDic];
        break;
    }
    return model;
}
@end

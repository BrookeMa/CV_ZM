//
//  ZMRouterPath.h
//  ZM_ThirdPartyLibraryExpand
//
//  Created by Chin on 2018/8/1.
//

#import <Foundation/Foundation.h>

@class ZMRouterModel;

@interface ZMRouterPath : NSObject

@property (nonatomic, strong) NSString * configName;    //默认为ZMRouter(.plist)

+ (instancetype)sharedInstance;

/**
 获取多有本地plist数据源
 
 @return 数据 XESRouterModel
 */
- (NSArray<ZMRouterModel *> *)getRouterList;

/**
 获取plist数据源
 
 @param plistName plist名称
 @return 数据 XESRouterModel
 */
- (NSArray<ZMRouterModel *> *)getRouterListWithPlistName:(NSString *)plistName;

/**
 根据key获取Router模型
 
 @param key 键值
 @return 返回model
 */
- (ZMRouterModel *)pathRouterModel:(NSString *)key;

@end

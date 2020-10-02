//
//  ZMNConstantsManager.h
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/30.
//

#import <Foundation/Foundation.h>

#define ZMNConstantsManagerInstance [ZMNConstantsManager sharedInstance]

typedef NS_ENUM(NSUInteger,ZMNNetWorkEnvironmentType){
    ZMNNetWorkEnvironmentTypeDevelop,           ///< 开发环境
    ZMNNetWorkEnvironmentTypeDistribution,      ///< 市场环境
};


@interface ZMNConstantsManager : NSObject

@property (nonatomic, assign) BOOL isOpenUMeng;///< YES:打开友盟，企业和市场都要打开，NO:关闭
@property (nonatomic, assign) ZMNNetWorkEnvironmentType networkEnvironmentType;///<设置网络环境
@property (nonatomic, copy) NSString * baseUrl;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedInstance;


@end

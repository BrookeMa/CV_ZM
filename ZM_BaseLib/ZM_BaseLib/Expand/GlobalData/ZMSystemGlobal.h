//
//  ZMSystemGlobal.h
//  ZM_BaseLib
//
//  Created by Chin on 2018/7/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 系统相关参数
 */
@interface ZMSystemGlobal : NSObject

/**
 单利初始化
 @return ZMSystemGlobal
 */
+ (instancetype)sharedInstance;

/**
 app唯一标识
 */
@property (strong, nonatomic) NSString * uuid;

/**
 APP build号
 */
@property (strong, nonatomic) NSString * build;

/**
 设备名称
 */
@property (strong, nonatomic) NSString * deviceName;

/**
 APP名字
 */
@property (strong, nonatomic) NSString * name;

/**
 APP版本
 */
@property (strong, nonatomic) NSString * version;

/**
 运营商类型
 */
@property (strong, nonatomic) NSString * carrier;

/**
 网络类型
 */
@property (strong, nonatomic) NSString * ac;

/**
 电量（0.0 to 1.0）
 */
@property (assign, nonatomic) CGFloat battery;

/**
 系统版本号
 */
@property (nonatomic) CGFloat syetemVersion;

/**
 屏幕尺寸(物理尺寸-宽)
 */
@property (nonatomic, readonly) CGFloat width;

/**
 屏幕尺寸(物理尺寸-高)
 */
@property (nonatomic, readonly) CGFloat height;

/**
 导航栏高度
 */
@property (nonatomic, readonly) CGFloat navBarHeight;

/**
 导航栏和状态栏高度
 */
@property (nonatomic, readonly) CGFloat navStatusBarHeight;

/**
 判断是否是iPhone X
 */
@property (nonatomic, readonly) BOOL isIphoneX;

/**
 是否是iPhoneX
 @return YES
 */
- (BOOL)isIphoneX;

@end

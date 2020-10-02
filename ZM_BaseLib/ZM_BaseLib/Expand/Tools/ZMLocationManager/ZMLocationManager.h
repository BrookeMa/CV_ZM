//
//  ZMLocationManager.h
//  ZM_BaseLib
//
//  Created by Chin on 2018/8/20.
//
// 1.下方参数需要在info.plist中配置
// Privacy - Location When In Use Usage Description 例如：请您允许，我们将会为您提供更精确的信息
// Privacy - Location Always Usage Description 例如：请您允许，我们将会为您提供更精确的信息
// 2.工程配置中的 Capabilities  ——>找到Background Modes 将off改成on 并且勾选 Location updates

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

typedef struct {
    CLLocationAccuracy desiredAccuracy;
    CLLocationDistance distanceFilter;
} ZMLocationConfig;

//定位发生变化时,执行的通知消息.
extern NSString * kZMLocaltionMangerDidUpdateLocation;


@interface ZMLocationManager : NSObject

@property (nonatomic, assign) ZMLocationConfig config;

@property (nonatomic, strong) CLPlacemark * currentPlaceMark;

+ (instancetype)sharedInstance;

- (void)startLocaltion;

- (void)stopUpdatingLocation;

@end

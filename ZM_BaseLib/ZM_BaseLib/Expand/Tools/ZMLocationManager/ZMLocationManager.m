//
//  ZMLocationManager.m
//  ZM_BaseLib
//
//  Created by Chin on 2018/8/20.
//

#import "ZMLocationManager.h"

NSString * kZMLocaltionMangerDidUpdateLocation = @"ZMLocationManagerDidUpdateLocation";


@interface ZMLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, assign) CLLocationAccuracy desiredAccuracy;
@property (nonatomic, strong) CLLocationManager * localtionManager;

@end

@implementation ZMLocationManager

+ (instancetype)sharedInstance
{
    static ZMLocationManager * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZMLocationManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        ZMLocationConfig config = {kCLLocationAccuracyBest, 100.f};
        self.config = config;
    }
    return self;
}

- (void)startLocaltion
{
    self.localtionManager.delegate = self;
    self.localtionManager.desiredAccuracy = self.config.desiredAccuracy;
    self.localtionManager.distanceFilter  = self.config.distanceFilter;
    
    if (@available(iOS 8.0, *)) {
        [self.localtionManager requestWhenInUseAuthorization];
    } else {
        // Fallback on earlier versions
    }
    
    if (@available(iOS 9.0, *)) {
        self.localtionManager.allowsBackgroundLocationUpdates = YES;
    } else {
        // Fallback on earlier versions
    }
    
    [self.localtionManager startUpdatingLocation];
    
}

- (void)stopUpdatingLocation
{
    [self.localtionManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate -

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            {
                if ([self.localtionManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                    [self.localtionManager requestAlwaysAuthorization];
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * location = locations.firstObject;
    CLLocationCoordinate2D coordinate2D = location.coordinate;
    NSLog(@"%f %f",coordinate2D.latitude,coordinate2D.longitude);
    
    [manager stopUpdatingLocation];
    
    __weak typeof(self) weakSelf = self;
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSLog(@"个数%ld",placemarks.count);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (CLPlacemark * place in placemarks) {
            weakSelf.currentPlaceMark = place;
            [[NSNotificationCenter defaultCenter] postNotificationName:kZMLocaltionMangerDidUpdateLocation object:strongSelf.currentPlaceMark];
        }
        
    }];
    
}


- (CLLocationManager *)localtionManager
{
    if (_localtionManager == nil) {
        _localtionManager = [[CLLocationManager alloc] init];
    }
    return _localtionManager;
}

@end

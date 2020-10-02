//
//  ZMSystemGlobal.m
//  ZM_BaseLib
//
//  Created by Chin on 2018/7/26.
//

#import "ZMSystemGlobal.h"
#import "sys/utsname.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import "ZMNetworkInfo.h"


@interface ZMSystemGlobal()

@property (strong, nonatomic) CTTelephonyNetworkInfo * netinfo;
@property (strong, nonatomic) ZMNetworkInfo * zmNetworkInfo;

@end

@implementation ZMSystemGlobal

+ (instancetype)sharedInstance
{
    __strong static ZMSystemGlobal * _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.netinfo = [[CTTelephonyNetworkInfo alloc] init];
        self.zmNetworkInfo = [ZMNetworkInfo sharedInstance];
    }
    return self;
}

- (NSString *)uuid
{
    NSString * uuidString = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"uuid==%@",uuidString);
    return uuidString;
}

- (CGFloat )syetemVersion
{
    return [[UIDevice currentDevice].systemVersion floatValue];
}

- (NSString *)build
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *)name
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}
- (NSString *)version
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)carrier
{
    CTCarrier * carrier = [self.netinfo subscriberCellularProvider];
    return [carrier carrierName] == nil? @"" : [carrier carrierName];;
}

- (NSString *)ac
{
    switch (self.zmNetworkInfo.networkType) {
        case ZMNetworkType_Unknown:
        {
            return @"Unknown";
        }
            break;
        case ZMNetworkType_None:
        {
            return @"None";
        }
            break;
        case ZMNetworkType_2G:
        {
            return @"2G";
        }
            break;
        case ZMNetworkType_3G:
        {
            return @"3G";
        }
            break;
        case ZMNetworkType_4G:
        {
            return @"4G";
        }
            break;
        case ZMNetworkType_WiFi:
        {
            return @"WiFi";
        }
            break;
        default:
        {
            return @"Unknown";
        }
            break;
    }
    return @"Unknown";
}

- (CGFloat)battery
{
    return [UIDevice currentDevice].batteryLevel;
}

- (CGFloat)height
{
    return [UIScreen mainScreen].bounds.size.height;
}
- (CGFloat)width
{
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)statusBarHeight
{
    return 20.f;
}

- (CGFloat)navBarHeight
{
    return 44.f;
}

- (CGFloat)navStatusBarHeight
{
    return (self.statusBarHeight + self.navBarHeight);
}


- (NSString *)deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3 (Wi-Fi)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3 (Wi-Fi + Cellular)";
    
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (Wi-Fi)";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2 (Wi-Fi + Cellular)";
    
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

- (BOOL)isIphoneX 
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,   2436), [[UIScreen mainScreen] currentMode].size) : NO);
}


@end

//
//  ZMDateManager.h
//  ZM_BaseLib
//
//  Created by Ye Ma on 2018/9/11.
//

#import <Foundation/Foundation.h>

@interface ZMDateManager : NSObject

/**
 获取当前时间戳
 
 @return 获取当前时间戳 秒
 */
+ (NSTimeInterval)getCurrentTimeInterval;

/**
 获取当前时间戳
 
 @return 获取当前时间戳 毫秒
 */
+ (long long)getCurrentTimeIntervalMiliseconded;

/**
 将日期转为YYYY-MM-dd格式的年月日
 
 @param timeInterval 要转换的时间戳
 @return 转化后的时间格式
 */
+ (NSString *)tranferToYYYYMMDDFrom:(NSNumber *)timeInterval;

@end

//
//  ZMDateManager.m
//  ZM_BaseLib
//
//  Created by Ye Ma on 2018/9/11.
//

#import "ZMDateManager.h"

@implementation ZMDateManager

/**
 获取当前时间戳

 @return 获取当前时间戳 秒
 */
+ (NSTimeInterval)getCurrentTimeInterval {
    return ceil([[NSDate date] timeIntervalSince1970]);
}

/**
 获取当前时间戳
 
 @return 获取当前时间戳 毫秒
 */
+ (long long)getCurrentTimeIntervalMiliseconded {
    return ceil([[NSDate date] timeIntervalSince1970] * 1000);
}

/**
 将日期转为YYYY-MM-dd格式的年月日

 @param timeInterval 要转换的时间戳
 @return 转化后的时间格式
 */
+ (NSString *)tranferToYYYYMMDDFrom:(NSNumber *)timeInterval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]];
    return [formatter stringFromDate:date];
}

@end

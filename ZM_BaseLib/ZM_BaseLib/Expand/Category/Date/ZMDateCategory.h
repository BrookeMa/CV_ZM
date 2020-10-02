//
//  ZMDateCategory.h
//  ZM_BaseLib
//
//  Created by Chin on 2018/7/26.
//  时间Category 和 时间工具类。

#import <Foundation/Foundation.h>


@interface NSDate (ZMTools)

/**
 返回时间字符串[年，月，日，分].

 @return 格式:@"yyyy-MM-dd HH:mm"
 */
- (NSString *)yearMonthDayHourMinString;

/**
 返回时间字符串[年，月，日，小时，分]（中文单位）.

 @return 格式:@"yyyy年MM月dd日 HH:mm".
 */
- (NSString *)yearMonthDayChineseHourMinString;

/**
 返回时间字符串[年，月，日，小时，分，秒].

 @return 格式:@"yyyy-MM-dd HH:mm:ss".
 */
- (NSString *)yearMonthDayHourMinSecString;

@end


@interface NSString (ZMDateTools)

/**
 将某个时间字符串通过格式 转化成 时间戳.

 @param format 格式举例:@"YYYY-MM-dd hh:mm:ss"
 @return 时间戳.
 */
- (NSInteger)timeSwitchTimestampWithFormatter:(NSString *)format;

/**
 将某个时间戳通过格式 转化成 时间字符串(举例格式@"12月11号 11:59").
 
 @param format 格式举例:@"MM月dd日 HH:mm".
 @return 时间.
 */
- (NSString *)timestampSwitchTimeWithFormatter:(NSString *)format;

@end


@interface ZMTimeConvertTool: NSObject

+ (NSString *)formateDate:(NSNumber *)dateTime withCurrentTime:(NSNumber *) currentTime ;

/**
 获取当前时间的 时间戳（函数内部使用的北京时区）.
 
 @return 输出格式:@"YYYY-MM-dd HH:mm:ss"(函数内部:timeIntervalSince1970).
 */
+ (NSInteger)getNowTimestamp;

@end


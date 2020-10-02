//
//  AppDelegate+DateCategory.m
//  ZM_BaseLib
//
//  Created by Chin on 2018/7/26.
//

#import "ZMDateCategory.h"

#pragma mark - NSDate
@implementation NSDate (ZMTools)

- (NSString *)yearMonthDayHourMinString
{
    return [self formattedStringWithFormat:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)yearMonthDayChineseHourMinString
{
    return [self formattedStringWithFormat:@"yyyy年MM月dd日 HH:mm"];
}

- (NSString *)yearMonthDayHourMinSecString
{
    return [self formattedStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)formattedStringWithFormat:(NSString *)format
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString * ret = [formatter stringFromDate:self];
    return ret;
}

@end

#pragma mark - NSString
@implementation NSString (ZMDateTools)

- (NSInteger)timeSwitchTimestampWithFormatter:(NSString *)format
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate * date = [formatter dateFromString:self];
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}

- (NSString *)timestampSwitchTimeWithFormatter:(NSString *)format
{
    NSString * timestampNew   = self;
    long long  timestampValue = [self longLongValue];
    timestampValue = timestampValue /1000;
    timestampNew   = [NSString stringWithFormat:@"%lld",timestampValue];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //设置格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    
    NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate * confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestampNew intValue]];
    NSString * confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

@end

#pragma mark - Date Tools
@implementation ZMTimeConvertTool

#pragma mark - 使用服务器时间，处理页面时间显示 dateTime 显示的时间  currenTime服务器当前时间
+ (NSString *)formateDate:(NSNumber *)dateTime withCurrentTime:(NSNumber *) currentTime
{
    if (dateTime && currentTime)
    {
        NSTimeInterval createTime  = [dateTime doubleValue] * 0.001;
        NSTimeInterval currenttime = [currentTime doubleValue] * 0.001;
        NSDate * datetime = [NSDate dateWithTimeIntervalSince1970:createTime];
        NSDate * current  = [NSDate dateWithTimeIntervalSince1970:currenttime];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];//设置时区，此处设为东8即北京时间
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [current timeIntervalSinceDate:datetime];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        NSString * dateStr = @"";
        if (time <= 60)
        {
            // 1分钟以内的
            dateStr = @"刚刚";
        }
        else if(time <= 60*60)
        {
            //  一个小时以内的
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        }
        else if(time <= 60*60*24)
        {
            // 在两天内的
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:datetime];
            NSString * now_yMd  = [dateFormatter stringFromDate:current];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                // 在同一天
                dateStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datetime]];
            }else{
                //  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:datetime]];
            }
        }
        else
        {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:datetime];
            NSString * nowYear = [dateFormatter stringFromDate:current];
            
            if ([yearStr isEqualToString:nowYear]) {
                //  在同一年
                [dateFormatter setDateFormat:@"MM月dd日"];
                dateStr = [dateFormatter stringFromDate:datetime];
            }else{
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                dateStr = [dateFormatter stringFromDate:datetime];
            }
        }
        return dateStr;
    }else{
        return @"";
    }
    return @"";
}

//获取当前系统时间的时间戳

#pragma mark - 获取当前时间的 时间戳

+ (NSInteger)getNowTimestamp
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //格式设置,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate * datenow = [NSDate date];
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    return timeSp;
}

@end

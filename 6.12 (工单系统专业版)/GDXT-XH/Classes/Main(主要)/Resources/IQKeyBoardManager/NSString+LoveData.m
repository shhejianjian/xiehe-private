//
//  NSString+LoveData.m
//  LoveData
//
//  Created by DaBin on 15/8/18.
//  Copyright (c) 2015年 xieyan. All rights reserved.
//

#import "NSString+LoveData.h"

@implementation NSString (LoveData)

+ (NSString *)stringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

//+ (NSString*)stringFromTimestamp:(NSString *)timestamp{
//    NSString *dateString = [NSString stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]]];
//    return dateString;
//}

+ (NSString*)stringFromTimestamp:(NSString *)timestamp{
    NSString *dateString = [NSString formatPostDate:[NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]]];
    return dateString;
}

+ (NSString *)formatPostDate:(NSDate *)date
{
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    NSInteger currentYear = [currentComps year];
    NSDateComponents *postComps = [currentCalendar components:unitFlags fromDate:date];
    NSInteger postYear = [postComps year];
    
    NSString *customizedDate = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    NSTimeInterval interval = [date timeIntervalSinceNow];
    if (interval <= 0) {
        interval = (-1) * interval;
        if (interval < 10) {
            customizedDate = @"刚刚";
        } else if (interval >= 10 && interval < 60) {
            customizedDate = [NSString stringWithFormat:@"%.f秒前", interval];
        } else if (interval >= 60 && interval < 30 * 60) {
            customizedDate = [NSString stringWithFormat:@"%.f分钟前", interval / 60];
        } else if (interval >= 30 * 60 && interval < 60 * 60) {
            customizedDate = [NSString stringWithFormat:@"半小时前"];
        } else if (interval >= 60 * 60 && interval < 24 * 60 * 60) {
            customizedDate = [NSString stringWithFormat:@"%.f小时前", interval / (60 * 60)];
        } else if (interval >= 24 * 60 * 60 && interval < 7 * 24 * 60 * 60) {
            customizedDate = [NSString stringWithFormat:@"%.f天前", interval / (24 * 60 * 60)];
        } else {
            if (postYear == currentYear) {
                [dateFormatter setDateFormat:@"MM月dd日"];
            } else {
                [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            }
            customizedDate = [dateFormatter stringFromDate:date];
        }
    } else {
        if (interval < 30) { // 服务器与App时间差容忍度
            customizedDate = @"刚刚";
        } else {
            if (postYear == currentYear) {
                [dateFormatter setDateFormat:@"MM月dd日"];
            } else {
                [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            }
            customizedDate = [dateFormatter stringFromDate:date];
        }
    }
    return customizedDate;
}


- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self, CFSTR(""),kCFStringEncodingUTF8));
    return result;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)stringWithStringEncodedHtml:(NSString *)string {
    
    NSString *result =  [[[[[[[[[[[string  stringByReplacingOccurrencesOfString:@"\\&" withString:@"&"] stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"] stringByReplacingOccurrencesOfString:@"&gt;" withString:@">" ] stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""] stringByReplacingOccurrencesOfString:@"&amp;nbsp;" withString:@""] stringByReplacingOccurrencesOfString:@"&amp;lt;" withString:@"<"]stringByReplacingOccurrencesOfString:@"&amp;gt;" withString:@">"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "]stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"]stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    return result;
}
@end

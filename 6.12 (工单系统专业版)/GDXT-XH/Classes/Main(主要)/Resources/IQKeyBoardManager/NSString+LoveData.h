//
//  NSString+LoveData.h
//  LoveData
//
//  Created by DaBin on 15/8/18.
//  Copyright (c) 2015年 xieyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LoveData)


/**
 *  时间戳转换时间
 *
 *  @param timestamp 时间戳（数字字符串）
 *
 *  @return NSString
 */
+ (NSString*)stringFromTimestamp:(NSString *)timestamp;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  Html转化为String
 *
 *  @param string 带有Html的String
 *
 *  @return 转化后的标准String
 */
+ (NSString*)stringWithStringEncodedHtml:(NSString *)string;

@end

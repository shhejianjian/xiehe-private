//
//  XHDepartment.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/9.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHDepartment.h"
#import "MJExtension.h"
@implementation XHDepartment
//+ (void)load
//{
//#pragma mark 如果使用NSObject来调用这些方法，代表所有继承自NSObject的类都会生效
//#pragma mark NSObject中的ID属性对应着字典中的id
//    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//    }];
//}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"items" : @"XHDepartment"
             };
}
MJCodingImplementation
@end

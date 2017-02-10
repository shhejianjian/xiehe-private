
//
//  XHOption.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHOption.h"
#import "MJExtension.h"
@implementation XHOption
+ (void)load
{
#pragma mark 如果使用NSObject来调用这些方法，代表所有继承自NSObject的类都会生效
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"desc" : @"description"
                 };
    }];
}

@end

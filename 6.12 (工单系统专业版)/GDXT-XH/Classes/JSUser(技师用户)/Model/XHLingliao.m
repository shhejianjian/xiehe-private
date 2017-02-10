//
//  XHLingliao.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHLingliao.h"

@implementation XHLingliao
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"items" : @"XHSubLingliao"
             };
}
- (NSMutableArray *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc]init];
    }
    return _items;
}
@end

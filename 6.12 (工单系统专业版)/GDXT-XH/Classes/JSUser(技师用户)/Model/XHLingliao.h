//
//  XHLingliao.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHLingliao : NSObject
/**
 *  领料类名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  领料数组
 */
@property (nonatomic, strong) NSMutableArray *items;
@end

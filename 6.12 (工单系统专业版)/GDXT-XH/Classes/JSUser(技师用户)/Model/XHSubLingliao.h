//
//  XHSubLingliao.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHSubLingliao : NSObject
/**
 *  领料名字
 */
@property (nonatomic, copy) NSString *name;
/**
 *  领料id
 */
@property (nonatomic, copy) NSString *objectId;
/**
 *  领料的单位(如米、桶)
 */
@property (nonatomic, copy) NSString *unit;
/**
 *  用来标记材料是否选中
 */
@property (nonatomic, assign, getter = isSelected) BOOL selected;
/**
*  用来标记选中材料的数量
*/
@property (nonatomic, copy) NSString *count;


@end

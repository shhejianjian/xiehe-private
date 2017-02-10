//
//  XHAssist.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/25.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHAssist : NSObject
/**
 *  协助人的电话
 */
@property (nonatomic, copy)  NSString *telephone;
/**
 *  协助人的标记id
 */
@property (nonatomic, copy)  NSString *objectId;
/**
 *  协助人的名字
 */
@property (nonatomic, copy)  NSString *name;
///**
// *  用来标记是否勾选
// */
//@property (nonatomic, assign, getter = isChecking) BOOL checking;

@property (nonatomic, copy)  NSString *assist;
@end

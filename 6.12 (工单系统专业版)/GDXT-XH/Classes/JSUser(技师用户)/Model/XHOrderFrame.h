//
//  XHOrderFrame.h
//  test
//
//  Created by 谢琰 on 16/5/29.
//  assignright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHOrder;

@interface XHOrderFrame : NSObject

@property (nonatomic, strong) XHOrder *order;
/**
 *  派单人员
 */
@property (nonatomic, assign) CGRect distributorF;
/**
 *  派单时间
 */
@property (nonatomic ,assign) CGRect distributeTimeF;
/**
 *  接单人员
 */
@property (nonatomic, assign) CGRect receiverF;
/**
 *  接单时间
 */
@property (nonatomic, assign) CGRect receiveTimeF;
/**
 *  领料情况（由数组拼接而成）
 */
@property (nonatomic, assign) CGRect materialF;
/**
 *  到达时间
 */
@property (nonatomic, assign) CGRect arriveTimeF;
/**
 *  挂单时间
 */
@property (nonatomic, assign) CGRect hangUpTimeF;
/**
 *  结单时间
 */
@property (nonatomic, assign) CGRect completeTimeF;
/**
 *  cell的高度(包含底部按钮的高度)
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end

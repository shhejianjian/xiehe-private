//
//  XHOrder.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/5.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XHOrder : NSObject
/**
 *  用来标记是否展开
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;
/**
 *  报修人员
 */
@property (nonatomic ,copy) NSString *requestUser;
/**
 *  报修时间
 */
@property (nonatomic ,copy) NSString *requestTime;
/**
 *  报修地点
 */
@property (nonatomic ,copy) NSString *building;
@property (nonatomic, copy) NSString *address;
@property (nonatomic ,copy) NSString *requestDepartment;
/**
 *  维修类型
 */
@property (nonatomic ,copy) NSString *type;
/**
 *  维修内容
 */
@property (nonatomic ,copy) NSString *equipment;
@property (nonatomic ,copy) NSString *faultType;
/**
 *  是否时限
 */
@property (nonatomic ,copy) NSString *processingTimeLimit;
/**
 *  受理人员
 */
@property (nonatomic ,copy) NSString *issuer;
/**
 *  受理时间
 */
@property (nonatomic ,copy) NSString *issueTime;
/**
 *  派单时间
 */
@property (nonatomic ,copy) NSString *distributeTime;
/**
 *  派单人员
 */
@property (nonatomic, copy) NSString *distributor;
/**
 *  接单时间
 */
@property (nonatomic, copy) NSString *receiveTime;
/**
 *  接单人员
 */
@property (nonatomic, copy) NSString *receiver;
/**
 *  到达时间
 */
@property (nonatomic, copy) NSString *arriveTime;
/**
 *  挂单时间
 */
@property (nonatomic, copy) NSString *hangUpTime;

/**
 *  结单时间
 */
@property (nonatomic, copy) NSString *completeTime;
/**
 *  领料（数组）
 */
@property (nonatomic, copy) NSArray *supplyList;
/**
 *  工单状态
 */
@property (nonatomic, copy) NSString *status;
/**
 *  领料情况（由数组拼接而成）
 */
@property (nonatomic, copy, readonly) NSMutableString *materialStr;
/**
 *  右上角的图标
 */
@property (nonatomic, copy) NSString *imageUrl;
/**
 *  每个订单都有个workOrderId
 */
@property (nonatomic, copy)NSString *workOrderId;
/**
 *  用来判断order可以进行哪些操作(接单、到达、操作等)
 */
@property (nonatomic, copy)NSString *statusTag;
///**
// *  用来保存是否隐藏订单底部的两个按钮(左)
// */
//@property (nonatomic, assign) BOOL hiddenLeftButton;
///**
// *  用来保存是否隐藏订单底部的两个按钮(左)
// */
//@property (nonatomic, assign) BOOL hiddenRightButton;
//
/**
 *  用来保存底部右边按钮的文字(状态)
 */
@property (nonatomic, copy) NSString *buttonTitle;
@property (nonatomic, copy) NSString *operatorName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *callNumber;
@property (nonatomic, copy) NSString *receiverPhone;
@end

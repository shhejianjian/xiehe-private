//
//  XHSummary.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/6/1.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHSubSummary;
@interface XHSummary : NSObject
/** 平均完成时间 */
@property (nonatomic, assign) int AvgCompleteTime;
/** 平均响应时间 */
@property (nonatomic, assign) int AvgArriveTime;
/** 各项的数量模型 */
@property (nonatomic, strong) XHSubSummary *workOrderStatus;

@end

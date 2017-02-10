//
//  XHSubSummary.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/6/1.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHSubSummary : NSObject
/** 工作中数量 */
@property (nonatomic, assign) int Arrive;
/** 下单单数量 */
@property (nonatomic, assign) int Issue;
/** 已结单数量 */
@property (nonatomic, assign) int Complete;
/** 挂单数量 */
@property (nonatomic, assign) int HangUp;
/** 需复核数量 */
@property (nonatomic, assign) int Review;
@property (nonatomic, assign) int Receive;
@property (nonatomic, assign) int Distribute;
@end

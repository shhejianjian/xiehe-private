//
//  XHWarn.h
//  GDXT-XH
//
//  Created by 何键键 on 16/5/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHWarn : NSObject
@property (nonatomic ,copy) NSString *category;
@property (nonatomic ,copy) NSString *degree;
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *workOrderRequestTime;
@property (nonatomic ,copy) NSString *workOrderContent;
@property (nonatomic ,copy) NSString *lastUpdateTime;
@property (nonatomic ,copy) NSString *message;
@property (nonatomic ,copy) NSString *objectId;
@property (nonatomic ,copy) NSString *deleteFlag;
@property (nonatomic ,copy) NSString *createTime;
@property (nonatomic ,copy) NSString *workOrderId;

@end

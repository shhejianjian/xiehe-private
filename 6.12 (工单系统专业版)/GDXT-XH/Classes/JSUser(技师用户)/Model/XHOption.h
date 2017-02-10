//
//  XHOption.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHOption : NSObject

@property (nonatomic, copy) NSString *parent;
@property (nonatomic, copy) NSString *lastUpdateTime;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *deleteFlag;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *createTime;
/**
 *  选项的id(上传是要用)
 */
@property (nonatomic, copy) NSString *objectId;
/**
 *  选项的的名称(上传是要用)
 */
@property (nonatomic, copy) NSString *name;
@end

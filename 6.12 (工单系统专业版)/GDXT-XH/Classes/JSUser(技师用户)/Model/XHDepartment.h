//
//  XHDepartment.h
//  GDXT-XH
//
//  Created by 何键键 on 16/5/9.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHDepartment : NSObject
@property (nonatomic ,copy) NSString *orderNo;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *ID;
@property (nonatomic ,copy) NSString *code;
@property (nonatomic ,copy) NSString *leaf;
@property (nonatomic ,copy) NSString *objectId;
@property (nonatomic ,strong) NSArray *items;
@end

//
//  XHMaterial.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/12.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHMaterial : NSObject
@property (nonatomic, copy) NSString *materialModel;
/**
 *  领料数量
 */
@property (nonatomic, assign) int amount;
/**
 *  领料标识1 objectId
 */
@property (nonatomic, copy) NSString *objectId;
/**
 *  领料名称（解析时）
 */
@property (nonatomic, copy) NSString *materialName;
/**
 * 领料标识2 materialId
 */
@property (nonatomic, copy) NSString *materialId;
/**
 *  领料情况
 */
@property (nonatomic, copy) NSString *materialInfo;
/**
 *  领料名称（上传时）
 */
@property (nonatomic, copy) NSString *name;

@end

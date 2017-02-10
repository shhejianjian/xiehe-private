//
//  XHUploadMaterial.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/24.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHMaterial;
@interface XHUploadMaterial : NSObject
@property (nonatomic, strong) XHMaterial *material;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, strong) NSString *materialInfo;
@end

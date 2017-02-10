//
//  XHOrder.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/5.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHOrder.h"
#import "MJExtension.h"
#import "XHMaterial.h"
@implementation XHOrder
{
    NSMutableString *_materialStr;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"supplyList" : @"XHMaterial"
             };
}
- (NSMutableString *)materialStr
{
    return [self getMaterialStr];
}
- (NSMutableString *)getMaterialStr
{
    NSMutableString *materialNameStr = [[NSMutableString alloc]init];
    NSMutableString *materialInfoStr = [[NSMutableString alloc]init];
    NSMutableArray *materialNames = [[NSMutableArray alloc]init];
    for (XHMaterial *material in self.supplyList) {
        if (material.materialInfo.length){
        materialInfoStr.length ?  [materialInfoStr appendString:[NSString stringWithFormat:@" %@",material.materialInfo]]:[materialInfoStr appendString:[NSString stringWithFormat:@"%@",material.materialInfo]];
        }
      
        if (material.materialName) {
            if (![materialNames containsObject:material.materialName]) {
                [materialNames addObject:material.materialName];
            }
        }
    }
    if (materialNames.count) {
        for (NSString *name in materialNames) {
            int  count = 0;
            for (XHMaterial *mate in self.supplyList) {
                if ([mate.materialName isEqualToString:name]) {
                    count  = count + mate.amount;
                }
            }
        materialNameStr.length ? [materialNameStr appendString:[NSString stringWithFormat:@" %@(%d)",name,count]] : [materialNameStr appendString:[NSString stringWithFormat:@"%@(%d)",name,count]];
        }
    }
    if (materialInfoStr.length) {
        materialNameStr.length ? [materialNameStr appendString:[NSString stringWithFormat:@"   %@",materialInfoStr]] : [materialNameStr appendString:[NSString stringWithFormat:@"%@",materialInfoStr]];
    }
    return materialNameStr;

}
@end

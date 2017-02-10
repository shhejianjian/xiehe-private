//
//  XHOptionUpload.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHOption;
@interface XHOptionUpload : NSObject
/**
 *  上传的选项选项
 */
@property (nonatomic, strong) XHOption *option;
/**
 *  上传时的说明
 */
@property (nonatomic, copy) NSString *remark;
/**
 *  上传文件(录音、视频等)成功返回的
 */
@property (nonatomic, copy) NSString *filename;

@end

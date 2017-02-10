//
//  XHSignatureView.h
//  sign
//
//  Created by 谢琰 on 16/5/18.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHSignatureView : UIView
+ (instancetype)signatureView;
+ (void)show;
//用来回调签名
@property (nonatomic, copy) void(^returnSignatureBlock)(NSString *signature);

@end

//
//  XHFooterView.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/16.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHFooterView;


@protocol XHFooterViewDelegate <NSObject>
@optional
- (void)footerViewButtonDidClick:(XHFooterView *)footerView;
@end

@interface XHFooterView : UIView
@property (nonatomic, weak) id<XHFooterViewDelegate>delegate;
@property (nonatomic, copy) NSString *btnTitle;
+ (instancetype)footerView;
@end

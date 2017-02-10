//
//  XHJieDanFooterView.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/17.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHJieDanFooterView;
@protocol XHJieDanFooterViewDelegate <NSObject>
@optional

- (void)jieDanFooterViewCheckButtonDidClick:(XHJieDanFooterView *)footerView;
- (void)jieDanFooterViewJieDanButtonDidClick:(XHJieDanFooterView *)footerView;

@end
@interface XHJieDanFooterView : UITableViewCell
+ (instancetype)footerView;
@property (nonatomic, weak) id<XHJieDanFooterViewDelegate>delegate;

@end

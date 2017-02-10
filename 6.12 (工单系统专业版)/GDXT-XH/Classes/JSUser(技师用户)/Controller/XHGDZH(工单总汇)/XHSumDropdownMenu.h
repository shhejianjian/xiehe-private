//
//  XHSumDropdownMenu.h
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHSumDropdownMenu;
@protocol XHSumDropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(XHSumDropdownMenu *)menu;
- (void)dropdownMenuDidShow:(XHSumDropdownMenu *)menu;

@end

@interface XHSumDropdownMenu : UIView
@property (nonatomic,weak) id<XHSumDropdownMenuDelegate> delegate;
+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@end

//
//  XHOperationViewController.h
//  GDXT-XH
//
//  Created by 何键键 on 16/4/21.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    XHOperationViewControllerButtonPhone,
    XHOperationViewControllerButtonVoice,
    XHOperationViewControllerButtonVideo,
    XHOperationViewControllerButtonAssist,
    XHOperationViewControllerButtonScan,
    XHOperationViewControllerButtonJieDan,
    XHOperationViewControllerButtonTuiDan,
    XHOperationViewControllerButtonYiDan,
    XHOperationViewControllerButtonGuaDan
} XHOperationViewControllerButton;

@class XHOperationViewController;

@protocol XHOperationViewControllerDelegate <NSObject>

@optional

- (void)operationViewController:(XHOperationViewController *)operationVc didClickButton:(XHOperationViewControllerButton)button;
@end

@interface XHOperationViewController : UIViewController
@property (assign, nonatomic)  BOOL isGuaDanHidden;
@property (weak, nonatomic) IBOutlet UIButton *guaDanBtn;
@property (weak, nonatomic) IBOutlet UILabel *guaDanLabel;
@property (nonatomic, weak) id<XHOperationViewControllerDelegate>delegate;
@end

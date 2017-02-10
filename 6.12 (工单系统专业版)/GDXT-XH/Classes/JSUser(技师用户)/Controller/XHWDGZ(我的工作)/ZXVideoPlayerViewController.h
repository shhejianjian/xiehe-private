//
//  ZXVideoPlayerViewController.h
//  demo
//
//  Created by shaw on 15/7/25.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHOrderFrame;
//@class ZXVideoPlayerViewController;
//@protocol ZXVideoPlayerViewControllerDelegate <NSObject>
//@optional
//- (void)ZXVideoPlayerViewControllerSureButtonDidClick:(ZXVideoPlayerViewController *)VC carryFileName:(NSString *)fileName;
//@end
@interface ZXVideoPlayerViewController : UIViewController
@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic,strong) NSData *data;
@property (nonatomic, strong) XHOrderFrame *mOrderFrame;
//@property (nonatomic, weak) id<ZXVideoPlayerViewControllerDelegate>delegate;
@end

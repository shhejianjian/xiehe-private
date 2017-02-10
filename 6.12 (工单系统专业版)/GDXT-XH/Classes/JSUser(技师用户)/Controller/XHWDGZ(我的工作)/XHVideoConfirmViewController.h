//
//  XHVideoConfirmViewController.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/30.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHOrderFrame;
@interface XHVideoConfirmViewController : UIViewController
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) XHOrderFrame *mOrderFrame;
@end

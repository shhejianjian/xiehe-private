//
//  XHZGPDViewController.h
//  GDXT-XH
//
//  Created by 何键键 on 16/5/19.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHOrderFrame;
@interface XHZGPDViewController : UIViewController
@property (nonatomic, strong) XHOrderFrame *orderFrame;
@property (nonatomic, copy) NSString *optionUrl;

@property (nonatomic, copy) NSString *workOrderId;

@end

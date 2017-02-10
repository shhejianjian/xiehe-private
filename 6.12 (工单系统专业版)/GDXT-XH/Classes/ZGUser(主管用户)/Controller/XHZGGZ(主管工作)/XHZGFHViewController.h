//
//  XHZGFHViewController.h
//  GDXT-XH
//
//  Created by 何键键 on 16/5/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHOrder,XHOrderFrame;
@interface XHZGFHViewController : UIViewController
@property (nonatomic, strong) XHOrderFrame *mOrderFrame;
@property (nonatomic, strong) XHOrder *fuheDetailOrder;
@property (nonatomic, strong) XHOrder *remarkOrder;
@property (nonatomic, copy) NSString *optionUrl;

@property (nonatomic, copy) NSString *workOrderId;

@end

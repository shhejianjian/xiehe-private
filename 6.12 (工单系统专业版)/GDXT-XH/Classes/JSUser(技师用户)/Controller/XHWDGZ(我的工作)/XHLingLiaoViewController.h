//
//  XHLingLiaoViewController.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/16.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHOrderFrame;
@interface XHLingLiaoViewController : UIViewController
/**
 *  传进来的order数据
 */
@property (nonatomic, strong) XHOrderFrame *mOrderFrame;
/**
 *  用来标记领料接口调成功通知哪个控制器更新数据
 */
@property (nonatomic, copy) NSString *notiStr;

@end

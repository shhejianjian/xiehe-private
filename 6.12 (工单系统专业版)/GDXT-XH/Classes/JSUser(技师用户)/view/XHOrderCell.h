//
//  XHOrderCell.h
//  GDXT-XH
//
//  Created by 何键键 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyperlinksButton.h"
typedef enum {
    XHDJDTableViewButtonLingLiao,
    XHDJDTableViewButtonCaozuo, //可能为接单 操作 到达
} XHDJDTableViewButton;

@class XHOrderCell,XHOrderFrame;
@protocol XHOrderCellDelegate <NSObject>
@optional
- (void)DJDTableViewCell:(XHOrderCell *)cell didClickButton:(XHDJDTableViewButton)button;
- (void)XHOrderCell:(XHOrderCell *)cell callTelClickButton:(NSInteger )index;
- (void)XHOrderCell:(XHOrderCell *)cell callTelTwoClickButton:(NSInteger )index;
@end

@interface XHOrderCell :UITableViewCell
@property (strong, nonatomic) XHOrderFrame *orderFrame;
@property (weak, nonatomic) IBOutlet UIButton *jieDanBtn;
@property (weak, nonatomic) IBOutlet UIButton *lingLiaoBtn;
@property (weak, nonatomic) id<XHOrderCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet HyperlinksButton *bxryBtn;
/** 接单人员 */
@property (nonatomic, weak) HyperlinksButton *receiverButton;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@end

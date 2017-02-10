//
//  XHLingliaoCenterCell.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHLingliaoCenterCell;
@protocol XHLingliaoCenterCellDelegate <NSObject>
@optional

- (void)lingliaoCenterCellButtonDidClick:(XHLingliaoCenterCell *)lingliaoCell;

@end


@interface XHLingliaoCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (nonatomic, weak) id<XHLingliaoCenterCellDelegate>delegate;
@end

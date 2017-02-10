//
//  XHSearchListCell.h
//  GDXT-XH
//
//  Created by 何键键 on 16/4/19.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHSearchListCell;
@protocol XHSearchListCellDelegate <NSObject>
@optional
- (void)XHSearchListCellClickButton:(XHSearchListCell *)cell AtIndex:(NSInteger)index;
- (void)XHSearchListCellDeleteButton:(XHSearchListCell *)cell AtIndex:(NSInteger)index;

@end


@interface XHSearchListCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *chooseTF;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) id<XHSearchListCellDelegate>delegate;
@end

//
//  XHLingliaoCenterCell.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHLingliaoCenterCell.h"
#import "XHConst.h"
@implementation XHLingliaoCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedButton.layer.cornerRadius = 5.0f;
    self.selectedButton.layer.masksToBounds = YES;
    self.selectedButton.layer.borderWidth = 1.0f;
    self.selectedButton.layer.borderColor = XHVoiceColor.CGColor;
 }
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }
    if ([self.delegate respondsToSelector:@selector(lingliaoCenterCellButtonDidClick:)]) {
        [self.delegate lingliaoCenterCellButtonDidClick:self];
    }
}

@end

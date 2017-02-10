//
//  XHSearchListCell.m
//  GDXT-XH
//
//  Created by 何键键 on 16/4/19.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSearchListCell.h"
#import "NSString+FontAwesome.h"

@interface XHSearchListCell ()

@end

@implementation XHSearchListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    [self.deleteBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconRemoveSign] forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    // Initialization code
}
- (IBAction)BtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(XHSearchListCellClickButton:AtIndex:)]) {
        [self.delegate XHSearchListCellClickButton:self AtIndex:sender.tag];
    }
}
- (IBAction)deleteBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(XHSearchListCellDeleteButton:AtIndex:)]) {
        [self.delegate XHSearchListCellDeleteButton:self AtIndex:sender.tag];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

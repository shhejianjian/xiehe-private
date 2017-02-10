
//
//  XHInstructionCell.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/16.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHInstructionCell.h"

@implementation XHInstructionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.instructionmentTextView.tintColor = [UIColor orangeColor];
    self.instructionmentTextView.layer.cornerRadius = 5.0f;
    self.instructionmentTextView.layer.borderWidth = 2.0f;
    self.instructionmentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.instructionmentTextView.layer.masksToBounds = YES;
}


@end

//
//  XHJieDanCenterCell.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/17.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHJieDanCenterCell.h"
@interface XHJieDanCenterCell()
@property (weak, nonatomic) IBOutlet UIButton *starOne;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
@property (weak, nonatomic) IBOutlet UIButton *starFive;

@end

@implementation XHJieDanCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)starOneDidClick:(UIButton *)sender {
    
    self.starOne.selected = YES;
    self.starTwo.selected = NO;
    self.starThree.selected = NO;
    self.starFour.selected = NO;
    self.starFive.selected = NO;
    if ([self.delegate respondsToSelector:@selector(jieDanCenterCell:didClickStar:)]) {
        [self.delegate jieDanCenterCell:self didClickStar:XHJieDanCenterCellStarOne];
    }

}
- (IBAction)starTwoDidClick:(UIButton *)sender {
    
    self.starOne.selected = YES;
    self.starTwo.selected = YES;
    self.starThree.selected = NO;
    self.starFour.selected = NO;
    self.starFive.selected = NO;
    if ([self.delegate respondsToSelector:@selector(jieDanCenterCell:didClickStar:)]) {
        [self.delegate jieDanCenterCell:self didClickStar:XHJieDanCenterCellStarTwo];
    }

}
- (IBAction)StarThreeDidClick:(UIButton *)sender {
    
    self.starOne.selected = YES;
    self.starTwo.selected = YES;
    self.starThree.selected = YES;
    self.starFour.selected = NO;
    self.starFive.selected = NO;
    if ([self.delegate respondsToSelector:@selector(jieDanCenterCell:didClickStar:)]) {
        [self.delegate jieDanCenterCell:self didClickStar:XHJieDanCenterCellStarThree];
    }

}
- (IBAction)StarFourDidClick:(UIButton *)sender {
    
    self.starOne.selected = YES;
    self.starTwo.selected = YES;
    self.starThree.selected = YES;
    self.starFour.selected = YES;
    self.starFive.selected = NO;
    if ([self.delegate respondsToSelector:@selector(jieDanCenterCell:didClickStar:)]) {
        [self.delegate jieDanCenterCell:self didClickStar:XHJieDanCenterCellStarFour];
    }

}
- (IBAction)StarFiveDidClick:(UIButton *)sender {
    
    self.starOne.selected = YES;
    self.starTwo.selected = YES;
    self.starThree.selected = YES;
    self.starFour.selected = YES;
    self.starFive.selected = YES;
    if ([self.delegate respondsToSelector:@selector(jieDanCenterCell:didClickStar:)]) {
        [self.delegate jieDanCenterCell:self didClickStar:XHJieDanCenterCellStarFive];
    }

}
- (IBAction)signBtnDidClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(jieDanCenterCellSignButtonDidClick:)]) {
        [self.delegate jieDanCenterCellSignButtonDidClick:self];
    }
}


@end

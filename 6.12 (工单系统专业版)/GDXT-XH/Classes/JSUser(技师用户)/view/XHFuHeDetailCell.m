//
//  XHFuHeDetailCell.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/26.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHFuHeDetailCell.h"
#import "XHOrder.h"
@interface XHFuHeDetailCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation XHFuHeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDetailOrder:(XHOrder *)detailOrder {
    self.nameLabel.text = [NSString stringWithFormat:@"技师:%@",detailOrder.operatorName];
}

- (void)setRemarkOrder:(XHOrder *)remarkOrder {
    self.detailLabel.text = [NSString stringWithFormat:@"复核说明:%@",remarkOrder.remark];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

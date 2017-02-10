//
//  XHWarnCell.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/17.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHWarnCell.h"
#import "XHWarn.h"
@interface XHWarnCell ()

@property (strong, nonatomic) IBOutlet UIView *detailView;

@end


@implementation XHWarnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 阴影颜色
    self.detailView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    // 阴影偏差
    self.detailView.layer.shadowOffset = CGSizeMake(1, 1);
    // 阴影不透明度
    self.detailView.layer.shadowOpacity = 0.8;
    //圆角
    self.detailView.layer.cornerRadius = 5.0f;
    // 边框宽度
    self.detailView.layer.borderWidth = 0.5f;
    //边框颜色
    self.detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Initialization code
}

- (void)setRedWarn:(XHWarn *)redWarn {
    self.titleLabel.text = redWarn.message;
    self.dateLabel.text = [self covertToDateStringFromString:redWarn.createTime];
}

- (void)setYellowWarn:(XHWarn *)yellowWarn {
    self.titleLabel.text = yellowWarn.message;
    self.dateLabel.text = [self covertToDateStringFromString:yellowWarn.createTime];

}
- (NSString *)covertToDateStringFromString:(NSString *)Str
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[Str longLongValue]/1000.0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

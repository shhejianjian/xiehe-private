//
//  XYTitleButton.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/18.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XYTitleButton.h"
#import "UIView+Extension.h"
#import "XHConst.h"
#define XYBadgeLableWitdh 8
#define badgeFont [UIFont systemFontOfSize:14]

@interface XYTitleButton()
@property (weak, nonatomic)  UILabel *badgeLable;
@property (nonatomic, assign) CGSize badgeSize;

@end
@implementation XYTitleButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *badgeLable = [[UILabel alloc]init];
        badgeLable.backgroundColor = XHTitleLabelColor;
        badgeLable.textAlignment = NSTextAlignmentCenter;
//        badgeLable.textColor = XHTitleLabelTextColor;
        badgeLable.font = [UIFont systemFontOfSize:14];
        self.badgeLable = badgeLable;
        [self addSubview:badgeLable];
    }
    return self;
}
- (void)setCountStr:(NSString *)countStr
{
    _countStr = [countStr copy];
    self.badgeLable.text = countStr;
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    self.badgeSize = [countStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :badgeFont} context:nil].size;
    [self layoutSubviews];

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.badgeLable.layer.cornerRadius = 6.0f;
    self.badgeLable.layer.masksToBounds = YES;
    self.badgeLable.x = self.titleLabel.x + self.titleLabel.width;
    self.badgeLable.centerY = self.titleLabel.centerY;
    self.badgeLable.size = self.countStr ? CGSizeMake(self.badgeSize.width + 5, self.badgeSize.height) : CGSizeMake(XYBadgeLableWitdh, XYBadgeLableWitdh);
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled: enabled];
    self.titleLabel.textColor = enabled ? XHTitleLabelTextColor : [UIColor whiteColor];
    self.badgeLable.textColor = enabled ? XHTitleLabelTextColor : [UIColor whiteColor];
}

@end

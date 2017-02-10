//
//  XHGuaDanCenterCell.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/17.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHGuaDanCenterCell.h"
#import "XHConst.h"
#import "MJExtension.h"
#import "XHHttpTool.h"
#import "XHOption.h"
#import "UIView+Extension.h"
@interface XHGuaDanCenterCell()
@property (nonatomic, weak) UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSMutableArray *optionButtons;

@end
@implementation XHGuaDanCenterCell
- (NSMutableArray *)optionButtons
{
    if (!_optionButtons) {
        _optionButtons = [NSMutableArray array];
    }
    return _optionButtons;
}
- (void)awakeFromNib {
//    XHLogFunc;
    [super awakeFromNib];
}
- (void)setOptionUrl:(NSString *)optionUrl
{
    _optionUrl = [optionUrl copy];
    [self loadButtons];
       XHLog(@"请求的url%@",self.optionUrl);
}
/**
 *  加载按钮选项
 */
- (void)loadButtons
{
    [self.optionButtons removeAllObjects];
    [XHHttpTool get:self.optionUrl params:nil success:^(id json) {
        self.options = [XHOption mj_objectArrayWithKeyValuesArray:json];
        [self setupOptionButtons];
        XHLog(@"录音按钮%@",json);
    } failure:^(NSError *error) {
        XHLog(@"录音按钮失败%@",error);
    }];
}
/**
 *  创建按钮选项
 */
- (void)setupOptionButtons
{
    for (int i = 0; i < self.options.count; i ++) {
        UIButton *optionButton = [[UIButton alloc]init];
        optionButton.layer.cornerRadius = 3.0f;
        optionButton.layer.borderWidth = 1.0f;
        optionButton.layer.borderColor = XHVoiceColor.CGColor;
        optionButton.layer.masksToBounds = YES;
        XHOption *option = self.options[i];
        [optionButton setTitle:option.name forState:UIControlStateNormal];
        [optionButton setTitleColor:XHVoiceColor forState:UIControlStateNormal];
        optionButton.tag = i;
        [optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [optionButton setBackgroundImage:[UIImage imageNamed:@"voice_btn_selected"] forState:UIControlStateSelected];
        optionButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [optionButton addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [optionButton sizeToFit];
        [self.optionButtons addObject:optionButton];
        [self.buttonView addSubview:optionButton];
    }
    [self updateOptionButtonFrame];
}
- (void)updateOptionButtonFrame
{
    CGFloat margin = 10;
    for (int i = 0; i < self.optionButtons.count; i ++) {
        UIButton *optionButton = self.optionButtons[i];
        optionButton.height = 25;
        optionButton.width = optionButton.width + 10;
        if (i == 0) {//最前面的那个按钮
            optionButton.x = 0;
            optionButton.y = 0;
        }else{//其他按钮
            UIButton *lastOptionButton = self.optionButtons[i - 1];
            //计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastOptionButton.frame) + margin;
            //计算当前行右边的宽度
            CGFloat rightWidth = self.buttonView.width - leftWidth;
            if (rightWidth >= optionButton.width) {//按钮显示在当行
                optionButton.y = lastOptionButton.y;
                optionButton.x = leftWidth;
            }else{//显示在下一行
                optionButton.x = 0;
                optionButton.y = CGRectGetMaxY(lastOptionButton.frame) + margin;
            }
        }
    }
}
- (void)btnDidClick:(UIButton *)sender
{
//    sender.selected = !sender.isSelected;
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    if ([self.delegate respondsToSelector:@selector(GuaDanCenterCellOptionButtonDidClick:Option:)]) {
        [self.delegate GuaDanCenterCellOptionButtonDidClick:self Option:self.options[self.selectedButton.tag]];
    }
    
 }

@end

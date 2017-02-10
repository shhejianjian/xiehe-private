//
//  XHFooterView.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/16.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHFooterView.h"
@interface XHFooterView()
@property (weak, nonatomic) IBOutlet UIButton *footerButton;

@end
@implementation XHFooterView

+ (instancetype)footerView
{
    return [[NSBundle mainBundle]loadNibNamed:@"XHFooterView" owner:nil options:nil].lastObject;

}
- (void)setBtnTitle:(NSString *)btnTitle
{
    _btnTitle = [btnTitle copy];
    [self.footerButton setTitle:btnTitle forState:UIControlStateNormal];
}
- (IBAction)lingliaoBtnDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(footerViewButtonDidClick:)]) {
        [self.delegate footerViewButtonDidClick:self];
    }
}

@end

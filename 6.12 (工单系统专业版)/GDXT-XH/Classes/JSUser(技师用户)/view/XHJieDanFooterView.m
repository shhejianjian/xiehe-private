
//
//  XHJieDanFooterView.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/17.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHJieDanFooterView.h"
@interface XHJieDanFooterView()

@end
@implementation XHJieDanFooterView
+ (instancetype)footerView
{
     return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (IBAction)checkBtnDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jieDanFooterViewCheckButtonDidClick:)]) {
        [self.delegate jieDanFooterViewCheckButtonDidClick:self];
    }
}
- (IBAction)jieDanBtnDidClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(jieDanFooterViewJieDanButtonDidClick:)]) {
        [self.delegate jieDanFooterViewJieDanButtonDidClick:self];
    }
}

@end

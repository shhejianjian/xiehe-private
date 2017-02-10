//
//  XHOperationViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/4/21.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHOperationViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "NSString+FontAwesome.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeScanViewController.h"
#import "QRCodeGenerator.h"
@interface XHOperationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *paiZhaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *luYinBtn;
@property (weak, nonatomic) IBOutlet UIButton *sheXiangBtn;
@property (weak, nonatomic) IBOutlet UIButton *xieZhuBtn;
@property (weak, nonatomic) IBOutlet UIButton *saoMaBtn;
@property (weak, nonatomic) IBOutlet UIButton *jieDanBtn;
@property (weak, nonatomic) IBOutlet UIButton *tuiDanBtn;
@property (weak, nonatomic) IBOutlet UILabel *tuiDanLable;
@property (weak, nonatomic) IBOutlet UIButton *yiDanBtn;
@property (weak, nonatomic) IBOutlet UILabel *guaDanLable;
@property (weak, nonatomic) IBOutlet UILabel *yiDanLable;
@end

@implementation XHOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void) setUpUI {
    self.paiZhaoBtn.titleLabel.font = [UIFont fontWithName:@"Ionicons" size:55];
    [self.paiZhaoBtn setTitle:@"\uf118" forState:UIControlStateNormal];
    
    self.luYinBtn.titleLabel.font = [UIFont fontWithName:@"Ionicons" size:55];
    [self.luYinBtn setTitle:@"\uf204" forState:UIControlStateNormal];
    
    self.sheXiangBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:55];
    [self.sheXiangBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconFacetimeVideo] forState:UIControlStateNormal];
    
    self.xieZhuBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:50];
    [self.xieZhuBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconGroup] forState:UIControlStateNormal];
    
    self.saoMaBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:55];
    [self.saoMaBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconQrcode] forState:UIControlStateNormal];
    
    self.jieDanBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:55];
    [self.jieDanBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconOkSign] forState:UIControlStateNormal];
    if (self.isGuaDanHidden) {
        
        self.tuiDanBtn.hidden = YES;
        self.tuiDanLable.hidden = YES;
        
        self.guaDanBtn.titleLabel.font = [UIFont fontWithName:@"Ionicons" size:55];
        [self.guaDanBtn setTitle:@"\uf21d" forState:UIControlStateNormal];
        self.guaDanLable.text = @"移单";
        
        self.yiDanBtn.titleLabel.font = [UIFont fontWithName:@"Ionicons" size:55];
        [self.yiDanBtn setTitle:@"\uf37f" forState:UIControlStateNormal];
        self.yiDanLable.text = @"退单";


    }else{
        self.tuiDanBtn.titleLabel.font = [UIFont fontWithName:@"Ionicons" size:55];
        [self.tuiDanBtn setTitle:@"\uf37f" forState:UIControlStateNormal];
        
        self.yiDanBtn.titleLabel.font = [UIFont fontWithName:@"Ionicons" size:55];
        [self.yiDanBtn setTitle:@"\uf21d" forState:UIControlStateNormal];
        
        self.guaDanBtn.titleLabel.font = [UIFont fontWithName:@"Ionicons" size:55];
        [self.guaDanBtn setTitle:@"\uf3b6" forState:UIControlStateNormal];
    }
  }

- (IBAction)paiZhaoBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
        [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonPhone];
    }

}
- (IBAction)luYinBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
        [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonVoice];
    }
}
- (IBAction)sheXiangBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
        [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonVideo];
    }
}
- (IBAction)saoMaBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
        [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonScan];
    }
 }
- (IBAction)JieDanBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
        [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonJieDan];
    }

}
- (IBAction)tuiDanBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
        [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonTuiDan];
    }
  }
- (IBAction)yiDanBtnClick:(id)sender {
    if (self.isGuaDanHidden) {
        if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
            [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonTuiDan];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
            [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonYiDan];
        }
    }
  }
- (IBAction)guaDanBtnClick:(id)sender {
    if (self.isGuaDanHidden) {
        if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
            [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonYiDan];
        }

    }else{
        if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
            [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonGuaDan];
        }

    
    }
    
}
- (IBAction)xieZhuBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(operationViewController:didClickButton:)]) {
        [self.delegate operationViewController:self didClickButton:XHOperationViewControllerButtonAssist];
    }

}






@end

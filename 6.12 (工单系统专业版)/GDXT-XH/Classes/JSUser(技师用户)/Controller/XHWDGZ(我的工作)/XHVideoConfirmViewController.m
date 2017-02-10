//
//  XHVideoConfirmViewController.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/30.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHVideoConfirmViewController.h"
#import "NSString+FontAwesome.h"
#import "XHConst.h"
#import "XHHttpTool.h"
#import "XHOption.h"
#import "MJExtension.h"
#import "UIView+Extension.h"
#import "SVProgressHUD.h"
#import "XHOrder.h"
#import "XHOptionUpload.h"
#import "XHMyJobViewController.h"
#import "XHOrderFrame.h"
@interface XHVideoConfirmViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITextView *instructionTextView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, strong) NSMutableArray *optionButtons;
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation XHVideoConfirmViewController
- (NSMutableArray *)optionButtons
{
    if (!_optionButtons) {
        _optionButtons = [NSMutableArray array];
    }
    return _optionButtons;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadButtons];
    // Do any additional setup after loading the view from its nib.
}
/**
 *  加载按钮选项
 */
- (void)loadButtons
{
    [XHHttpTool get:vedioOptionUrl params:nil success:^(id json) {
        self.options = [XHOption mj_objectArrayWithKeyValuesArray:json];
        [self createOptionButtons];
        XHLog(@"录音按钮%@",json);
    } failure:^(NSError *error) {
        XHLog(@"录音按钮失败%@",error);
        
    }];
}

/**
 *  创建按钮选项
 */
- (void)createOptionButtons
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
        [self.buttonView addSubview:optionButton];
        [self.optionButtons addObject:optionButton];
        
    }
    //更新选项按钮的frame 如果多要换行
    [self updateOptionButtonFrame];
}
- (void)btnDidClick:(UIButton *)sender
{
    
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
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

- (void)setupUI
{
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    self.instructionTextView.tintColor = [UIColor orangeColor];
    self.instructionTextView.layer.cornerRadius = 5.0f;
    self.instructionTextView.layer.borderWidth = 2.0f;
    self.instructionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.instructionTextView.layer.masksToBounds = YES;
}
- (IBAction)uploadButtonDidClick:(id)sender {
    if (!self.selectedButton.titleLabel.text) {
        [SVProgressHUD showInfoWithStatus:@"请先选择一个摄像选项" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (!self.fileName) {
        [SVProgressHUD showInfoWithStatus:@"尚未摄像或上传摄像失败" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    NSString *uploadUrl = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/video",self.mOrderFrame.order.workOrderId];
    XHOptionUpload *optionUpload = [[XHOptionUpload alloc]init];
    XHOption *selectedOption = self.options[self.selectedButton.tag];
    XHOption *option = [[XHOption alloc]init];
    option.name = selectedOption.name;
    option.objectId = selectedOption.objectId;
    optionUpload.option = option;
    optionUpload.remark = self.instructionTextView.text;
    optionUpload.filename = self.fileName;
    [XHHttpTool put:uploadUrl params:optionUpload.mj_keyValues success:^(id json) {
        [SVProgressHUD showSuccessWithStatus:@"确认完成" maskType:SVProgressHUDMaskTypeBlack];
        [self popToJobVc];
//        [self.navigationController popViewControllerAnimated:YES];
        XHLog(@"上传成功%@-%@",json,optionUpload.mj_keyValues);
        
    } failure:^(NSError *error) {
        XHLog(@"上传失败%@-%@",error,optionUpload.mj_keyValues);
    }];
}

- (IBAction)back:(id)sender {
    [self popToJobVc];
}
- (void)popToJobVc {

    for (UIViewController *childVc in self.navigationController.viewControllers) {
        if ([childVc isKindOfClass:[XHMyJobViewController class]]) {
            [self.navigationController popToViewController:childVc animated:YES];
        }
    }
}


@end

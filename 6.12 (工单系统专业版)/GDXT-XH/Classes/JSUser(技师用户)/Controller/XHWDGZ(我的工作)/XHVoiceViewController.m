//
//  XHVoiceViewController.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/16.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHVoiceViewController.h"
#import "XHConst.h"
#import "IQKeyboardManager.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+FontAwesome.h"
#import "AFNetworking.h"
#import "XHOrder.h"
#import "SVProgressHUD.h"
#import "XHHttpTool.h"
#import "XHOption.h"
#import "MJExtension.h"
#import "UIView+Extension.h"
#import "XHOptionUpload.h"
#import "XHOrderFrame.h"
@interface XHVoiceViewController ()<AVAudioPlayerDelegate,NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITextView *instructionTextView;
@property (nonatomic, weak) UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
@property (nonatomic, copy) NSString *tempFilename;
//录音存储路径
@property (nonatomic, strong)NSURL *voiceUrl;
//录音
@property (nonatomic, strong)AVAudioRecorder *recorder;
//播放
@property (nonatomic, strong)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;
//请求出来的按钮选项数组
@property (nonatomic, strong)NSArray *options;
//用来显示按钮选项的父控件
@property (weak, nonatomic) IBOutlet UIView *buttonView;
//保存所有选项按钮
@property (nonatomic, strong) NSMutableArray *optionButtons;
@end

@implementation XHVoiceViewController
- (NSMutableArray *)optionButtons
{
    if (!_optionButtons) {
        _optionButtons = [NSMutableArray array];
    }
    return _optionButtons;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadButtons];
    [self setupUI];
    //设置录音相关的东西
    [self setupVoice];
//    self.isRecoding = NO;
}
/**
 *  加载按钮选项
 */
- (void)loadButtons
{
    [XHHttpTool get:recordOptionUrl params:nil success:^(id json) {
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

- (void)setupVoice
{
    //刚打开的时候录音状态为不录音
    self.isRecoding = NO;
    
    //创建文件来存放录音文件
    self.voiceUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"VoiceFile.caf"]];
    
    //设置后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    //判断后台有没有播放
    if (session == nil) {
    NSLog(@"Error creating sessing:%@", [sessionError description]);
    } else {
        [session setActive:YES error:nil];
    }
    
    NSError *playError;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.voiceUrl error:&playError];
//    self.player.delegate = self;
    
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
- (void)btnDidClick:(UIButton *)sender
{
    
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
//    self.selectedButton.tag = sender.tag;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  录音
 */
- (IBAction)btnVoiceClick:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"录音"]) {
        //开始录音,将所获取到得录音存到文件里
        
        self.recorder = [[AVAudioRecorder alloc] initWithURL:self.voiceUrl settings:nil error:nil];
        //准备记录录音
        [_recorder prepareToRecord];
        
        //启动或者恢复记录的录音文件
        [_recorder record];
        [sender setTitle:@"停止录音" forState:UIControlStateNormal];
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"停止录音"]) {
        //停止录音
        [_recorder stop];
        [sender setTitle:@"播放" forState:UIControlStateNormal];
        //上传录音
        [self uploadVoice];
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"播放"]) {
        //开始播放
        [_player play];
        [sender setTitle:@"停止播放" forState:UIControlStateNormal];
        return;
    }
    if ([sender.titleLabel.text isEqualToString:@"停止播放"]) {
        //暂停播放
        [_player pause];
        [sender setTitle:@"录音" forState:UIControlStateNormal];
        return;
    }

}
/**
 *  录音上传
 */
- (void)uploadVoice
{
    NSData *data = [NSData dataWithContentsOfURL:self.voiceUrl];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSString *uploadVoiceUrl = [NSString stringWithFormat:@"%@/%@",BaseUrl,uploadUrl];
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"Post" URLString:uploadVoiceUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"attachment" fileName:@"att.mp3" mimeType:@"audio/mp3"];
    } error:nil];
    AFHTTPRequestOperationManager  *manager=[AFHTTPRequestOperationManager  manager];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.tempFilename = responseObject[@"tempFilename"];
        NSLog(@"上传成功%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败%@",error);
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
  }];
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
     double f =  ((double)totalBytesWritten / totalBytesExpectedToWrite);
     [SVProgressHUD showProgress:f status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
        if (f >= 1.000000) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        }
    }];
    [operation start];
}
/**
 *  调接口
 */
- (IBAction)btnSureClick:(id)sender {
    if (!self.selectedButton.titleLabel.text) {
        [SVProgressHUD showInfoWithStatus:@"请先选择一个录音选项" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (!self.tempFilename) {
        [SVProgressHUD showInfoWithStatus:@"尚未录音或上传录音失败" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
   NSString *uploadUrl = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/soundRecord",self.mOrderFrame.order.workOrderId];
    XHOptionUpload *optionUpload = [[XHOptionUpload alloc]init];
    XHOption *selectedOption = self.options[self.selectedButton.tag];
    XHOption *option = [[XHOption alloc]init];
    option.name = selectedOption.name;
    option.objectId = selectedOption.objectId;
    optionUpload.option = option;
    optionUpload.remark = self.instructionTextView.text;
    optionUpload.filename = self.tempFilename;
    [XHHttpTool put:uploadUrl params:optionUpload.mj_keyValues success:^(id json) {
        [SVProgressHUD showSuccessWithStatus:@"确认完成" maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
        XHLog(@"上传成功%@-%@",json,optionUpload.mj_keyValues);

    } failure:^(NSError *error) {
        XHLog(@"上传失败%@-%@",error,optionUpload.mj_keyValues);
    }];
}
@end

//
//  XHLoginViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/3/30.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHLoginViewController.h"
#import "NSString+FontAwesome.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "XHMyJobViewController.h"
#import "XHLogin.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "XHZGJobViewController.h"
#import "XHLogin.h"
@interface XHLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *showImg;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton    *rememberMeBtn;
@property (weak, nonatomic) IBOutlet UILabel     *userNameIcon;
@property (weak, nonatomic) IBOutlet UILabel     *passwordIcon;
@property (weak, nonatomic) IBOutlet UILabel     *userTip;
@property (weak, nonatomic) IBOutlet UILabel     *passwordTip;
@property (nonatomic, strong) NSDictionary *dic;


@end

NSString *jsessionid;
XHMyJobViewController *mMyJobVc;
XHZGJobViewController *mZgJobVc;
NSString *userType;
@implementation XHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isRemember];
    [self updateUI];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)isRemember
{
    NSString *isRemember =  [[NSUserDefaults standardUserDefaults]objectForKey:@"isRemember"];
    if ([isRemember isEqualToString:@"Yes"]) {
        self.userNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        self.rememberMeBtn.selected = YES;
    }

}
- (void)updateUI {
    self.userTip.hidden = !self.userNameTextField.text.length;
    self.passwordTip.hidden = !self.passwordTextField.text.length;
    self.userNameIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
    self.userNameIcon.text = [NSString fontAwesomeIconStringForEnum:FAIconUser];
    self.passwordIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
    self.passwordIcon.text = [NSString fontAwesomeIconStringForEnum:FAIconLock];
    self.userNameTextField.tintColor = [UIColor orangeColor];
    self.passwordTextField.tintColor = [UIColor orangeColor];
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.rememberMeBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.rememberMeBtn setTitle:@"\uf279" forState:UIControlStateNormal];
    [self.rememberMeBtn setTitle:@"\uf26a" forState:UIControlStateSelected];
    [self.rememberMeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rememberMeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.userNameTextField == textField) {
        self.userNameIcon.textColor = [UIColor orangeColor];
        self.userTip.textColor = [UIColor orangeColor];
    } else {
        self.userNameIcon.textColor = [UIColor darkGrayColor];
        self.userTip.textColor = [UIColor lightGrayColor];
    }
    if (self.passwordTextField == textField) {
        self.passwordIcon.textColor = [UIColor orangeColor];
        self.passwordTip.textColor = [UIColor orangeColor];
    } else {
        self.passwordIcon.textColor = [UIColor darkGrayColor];
        self.passwordTip.textColor = [UIColor lightGrayColor];
    }
    return YES;
}


- (IBAction)userEditChange:(UITextField *)sender {
    self.userTip.hidden = NO;
    if (sender.text.length == 0) {
        self.userTip.hidden = YES;
    }
}
- (IBAction)passEditChange:(UITextField *)sender {
    self.passwordTip.hidden = NO;
    if (sender.text.length == 0) {
        self.passwordTip.hidden = YES;
    }
}

- (IBAction)rememberMeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
//    if (sender.selected) {
//        [self.rememberMeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
//    }
}
- (IBAction)loginClick:(id)sender {
    if (self.userNameTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
        return;
    }
    if (self.passwordTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
         return;
    }
    [self loginWithUsername:self.userNameTextField.text Password:self.passwordTextField.text];
    
    
}
- (void)loginWithUsername:(NSString *)username
                 Password:(NSString *)password{
    //显示指示器
    [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPSessionManager  *manager=[AFHTTPSessionManager  manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"username"] = username;
    params[@"password"] = password;
    [manager POST:LoginUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
       
        NSURLResponse *response = task.response;
        //转换NSURLResponse成为HTTPResponse
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        //获取headerfields
        NSDictionary *fields = [HTTPResponse allHeaderFields];
        if (fields[@"jsessionid"]) {
            [SVProgressHUD dismiss];
            NSUserDefaults *UserDefaults=[NSUserDefaults standardUserDefaults];
            XHLogin *login = [XHLogin mj_objectWithKeyValues:fields[@"currentUser"]];
            [UserDefaults setObject:username forKey:@"username"];
            [UserDefaults setObject:password forKey:@"password"];
            [UserDefaults setObject:self.rememberMeBtn.isSelected ? @"Yes" : @"NO" forKey:@"isRemember"];
            userType = login.role;
            if ([userType isEqualToString:@"Manager"]) {
                XHZGJobViewController *zgJobVc = [[XHZGJobViewController alloc]init];
                mZgJobVc = zgJobVc;
                [self.navigationController pushViewController:zgJobVc animated:YES];
            } else if ([userType isEqualToString:@"Artificer"]) {
                XHMyJobViewController *myJobVC = [[XHMyJobViewController alloc]init];
                mMyJobVc = myJobVC;
                [self.navigationController pushViewController:myJobVC animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"非法用户"];
                [self logOff];
            }

            [UserDefaults synchronize];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的用户名或密码"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录失败%@",error);
        [SVProgressHUD showErrorWithStatus:@"连接超时,请稍后再试"];
    }];
}
- (void)logOff
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    NSString *urlStr = @"http://192.168.7.100:8080/hems/logout";
    [manager POST:LogoutUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"退出失败"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

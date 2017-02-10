//
//  XHAssistViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/4/21.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHAssistViewController.h"
#import "NSString+FontAwesome.h"
#import "XHAssistCell.h"
#import "XHOrder.h"
#import "XHHttpTool.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"
#import "XHAssist.h"
#import "XHUploadAssist.h"
#import "XHAssistObjectId.h"
#import "XHOrderFrame.h"
static NSString *ID=@"assistCell";
@interface XHAssistViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *chooseAllBtn;
@property (strong, nonatomic) IBOutlet UIButton *certainBtn;
@property (strong, nonatomic) NSArray *assists;
@end

@implementation XHAssistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    [self loadAssists];
}
- (void)setupBasic
{
    [self.myTableView registerNib:[UINib nibWithNibName:@"XHAssistCell" bundle:nil] forCellReuseIdentifier:ID];
    
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    
    self.chooseAllBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.chooseAllBtn setTitle:@"\uf254" forState:UIControlStateNormal];
    
    self.certainBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.certainBtn setTitle:@"\uf26b" forState:UIControlStateNormal];

}
- (void)loadAssists
{
    //显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSString *assistUrl = [NSString stringWithFormat:@"hems/workOrder/%@/assist/artificer",self.mOrderFrame.order.workOrderId];
    [XHHttpTool get:assistUrl params:nil success:^(id json) {
        NSLog(@"协助%@",json);
        self.assists = [XHAssist mj_objectArrayWithKeyValuesArray:json];
        [SVProgressHUD dismiss];
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];

}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnChooseAllClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    sender.hidden = !sender.isSelected;
    self.certainBtn.hidden = sender.hidden;
    if (sender.isSelected) {
        for (XHAssist *assist in self.assists) {
            assist.assist  = @"1";
        }
    }else{
        for (XHAssist *assist in self.assists) {
            assist.assist  = @"0";
        }
    }
   
    self.titleLabel.text = sender.isSelected ? [NSString stringWithFormat:@"选中%lu",(unsigned long)self.assists.count] :  @"协助";
    [self.myTableView reloadData];
}
- (IBAction)btnCertainClick:(id)sender {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定协助?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView show];
 }
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"正在协助" maskType:SVProgressHUDMaskTypeBlack];
        NSMutableArray *uploadAssists = [[NSMutableArray alloc]init];
        for (XHAssist *assist in self.assists) {
            if ([assist.assist isEqualToString:@"1"]) {
                XHUploadAssist *uploadAssist = [[XHUploadAssist alloc]init];
                XHAssistObjectId *objectId = [[XHAssistObjectId alloc]init];
                objectId.objectId = assist.objectId;
                uploadAssist.artificer = objectId;
                [uploadAssists addObject:uploadAssist.mj_keyValues];
            }
        }
        //协助上传的url
        NSString *uploadUrl = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/assist",self.mOrderFrame.order.workOrderId];
        [XHHttpTool put:uploadUrl params:uploadAssists success:^(id json) {
            NSLog(@"协助成功%@",uploadAssists);
            [SVProgressHUD showSuccessWithStatus:@"协助完成"];
           [self.navigationController popViewControllerAnimated:YES];
         } failure:^(NSError *error) {
            NSLog(@"协助失败%@",uploadAssists);
            [SVProgressHUD showErrorWithStatus:@"协助失败"];
        }];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assists.count;
}
- (XHAssistCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHAssistCell *cell=[tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.assist = self.assists[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XHAssist *assist = self.assists[indexPath.row];
    assist.assist = [assist.assist isEqualToString:@"1"] ? @"0" :@"1";
    BOOL hasChecking = NO;
    NSInteger selectCount = 0;
    for (XHAssist *subAssist in self.assists) {
        if ([subAssist.assist isEqualToString:@"1"]) {
            hasChecking = YES;
            selectCount ++;
        }
    }
    self.titleLabel.text = selectCount == 0 ? @"协助" : [NSString stringWithFormat:@"选中%lu",(unsigned long)selectCount];
    // 根据有没有打钩的情况,决定按钮是否显示
    self.certainBtn.hidden = !hasChecking;
    self.chooseAllBtn.hidden = !hasChecking;
    [self.myTableView reloadData];
}

@end

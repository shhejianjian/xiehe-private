//
//  XHGuaDanViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/4/21.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHGuaDanViewController.h"
#import "NSString+FontAwesome.h"
#import "XHOrder.h"
#import "XHFooterView.h"
#import "XHOrderCell.h"
#import "XHGuaDanCenterCell.h"
#import "XHInstructionCell.h"
#import "XHConst.h"
#import "XHOption.h"
#import "SVProgressHUD.h"
#import "XHOptionUpload.h"
#import "XHHttpTool.h"
#import "MJExtension.h"
#import "XHOrderFrame.h"
@interface XHGuaDanViewController ()<UITableViewDelegate, UITableViewDelegate, XHFooterViewDelegate, XHGuaDanCenterCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *guaDanTableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) XHOption *selectedOption;

@end

@implementation XHGuaDanViewController
static NSString *ID1 = @"XHOrderDetailCell";
static NSString *ID2 = @"XHChooseCell";
static NSString *ID3 = @"XHInstructionCell";
extern NSString *userType;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupTableView
{
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    [self.guaDanTableView registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID1];
    
    [self.guaDanTableView registerNib:[UINib nibWithNibName:@"XHGuaDanCenterCell" bundle:nil] forCellReuseIdentifier:ID2];
    
    [self.guaDanTableView registerNib:[UINib nibWithNibName:@"XHInstructionCell" bundle:nil] forCellReuseIdentifier:ID3];
    
    XHFooterView *footerView = [XHFooterView footerView];
    footerView.btnTitle = @"挂单";
    footerView.delegate = self;
    self.guaDanTableView.tableFooterView = footerView;
}

//- (IBAction)backBtnClick:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        XHOrderCell *firstCell = [self.guaDanTableView dequeueReusableCellWithIdentifier:ID1];
        firstCell.orderFrame = self.mOrderFrame;
        firstCell.lingLiaoBtn.hidden = YES;
        firstCell.jieDanBtn.hidden = YES;
        cell = firstCell;
    }else if (indexPath.section == 1){
        XHGuaDanCenterCell *secondCell = [self.guaDanTableView dequeueReusableCellWithIdentifier:ID2];
        secondCell.optionUrl = hangupOptionUrl;
        secondCell.delegate = self;
        cell = secondCell;
    }else{
        XHInstructionCell *secondCell = [self.guaDanTableView dequeueReusableCellWithIdentifier:ID3];
        cell = secondCell;
        self.indexPath = indexPath;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section !=0 ) return;
    self.mOrderFrame.order.opened = !self.mOrderFrame.order.isOpened;
       [UIView animateWithDuration:0.7 animations:^{
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (self.mOrderFrame.order.isOpened ? self.mOrderFrame.cellHeight - 50: 200);
        }else if(indexPath.section == 1){
        return 120;
    }
    else{
        return 200;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"工单详情";
    }else if (section == 1){
        return @"挂单选项";
    }else{
        return @"挂单说明";
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor = [UIColor redColor];
}

#pragma mark - XHGuaDanFooterViewDelegate
- (void)GuaDanCenterCellOptionButtonDidClick:(XHGuaDanCenterCell *)cell Option:(XHOption *)option
{
    self.selectedOption = option;
}

#pragma mark - XHFooterViewDelegate
- (void)footerViewButtonDidClick:(XHFooterView *)footerView
{
    if (!self.selectedOption.name) {
        [SVProgressHUD showInfoWithStatus:@"请先选择一个挂单选项" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定挂单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView show];
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        XHInstructionCell *cell = [self.guaDanTableView cellForRowAtIndexPath:self.indexPath];
        NSString *uploadUrl = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/hangUp",self.mOrderFrame.order.workOrderId];
        XHOptionUpload *optionUpload = [[XHOptionUpload alloc]init];
        XHOption *option = [[XHOption alloc]init];
        option.name = self.selectedOption.name;
        option.objectId = self.selectedOption.objectId;
        optionUpload.option = option;
        optionUpload.remark = cell.instructionmentTextView.text;
        [XHHttpTool put:uploadUrl params:optionUpload.mj_keyValues success:^(id json) {
            [SVProgressHUD showSuccessWithStatus:@"挂单成功" maskType:SVProgressHUDMaskTypeBlack];
            [self.navigationController popViewControllerAnimated:YES];
            XHLog(@"上传成功%@-%@",json,optionUpload.mj_keyValues);
            
        } failure:^(NSError *error) {
            XHLog(@"上传失败%@-%@",error,optionUpload.mj_keyValues);
        }];
    }
}

@end

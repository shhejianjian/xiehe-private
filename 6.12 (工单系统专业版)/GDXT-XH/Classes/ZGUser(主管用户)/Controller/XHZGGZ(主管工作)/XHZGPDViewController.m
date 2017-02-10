//
//  XHZGPDViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/19.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHZGPDViewController.h"
#import "NSString+FontAwesome.h"
#import "XHOrder.h"
#import "XHFooterView.h"
#import "XHOrderCell.h"
#import "XHGuaDanCenterCell.h"
#import "XHInstructionCell.h"
#import "XHConst.h"
#import "XHOrderFrame.h"
#import "XHOption.h"
#import "XHHttpTool.h"
#import "SVProgressHUD.h"

@interface XHZGPDViewController ()<UITableViewDelegate, UITableViewDelegate, XHFooterViewDelegate, XHGuaDanCenterCellDelegate>
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITableView *ZGPDTableView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) NSString *optionId;
@end

@implementation XHZGPDViewController
static NSString *ID1 = @"XHOrderDetailCell";
static NSString *ID2 = @"XHChooseCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];

   

    // Do any additional setup after loading the view from its nib.
}
- (void)setupTableView
{
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    [self.ZGPDTableView registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID1];
    
    [self.ZGPDTableView registerNib:[UINib nibWithNibName:@"XHGuaDanCenterCell" bundle:nil] forCellReuseIdentifier:ID2];
    
    
    
    XHFooterView *footerView = [XHFooterView footerView];
    footerView.btnTitle = @"派单";
    footerView.delegate = self;
    self.ZGPDTableView.tableFooterView = footerView;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        XHOrderCell *firstCell = [self.ZGPDTableView dequeueReusableCellWithIdentifier:ID1];
        firstCell.orderFrame = self.orderFrame;
        
        XHOrder *order =  self.orderFrame.order;
        order.imageUrl = @"pai_con";
        
        firstCell.lingLiaoBtn.hidden = YES;
        firstCell.jieDanBtn.hidden = YES;
        cell = firstCell;
    }else if (indexPath.section == 1){
        XHGuaDanCenterCell *secondCell = [self.ZGPDTableView dequeueReusableCellWithIdentifier:ID2];
        secondCell.delegate = self;
        secondCell.optionUrl = self.optionUrl;
        cell = secondCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.orderFrame.order.opened = !self.orderFrame.order.isOpened;
        [UIView animateWithDuration:0.7 animations:^{
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return (self.orderFrame.order.isOpened ? self.orderFrame.cellHeight -50 : 200);
        
    }else if(indexPath.section == 1){
        
        return 120;

    }
        return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"工单详情";
    }else if (section == 1){
        return @"选择技师";
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor = [UIColor redColor];
}

#pragma mark - XHGuaDanFooterViewDelegate
- (void)guaDanFooterViewOptionButtonDidClick:(XHGuaDanCenterCell *)footerView Option:(XHOption *)option {
    _optionId = option.objectId;
}


#pragma mark - XHFooterViewDelegate
- (void)footerViewButtonDidClick:(XHFooterView *)footerView
{
    NSString *url = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/distribute?userId=%@",self.workOrderId,self.optionId];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认派单？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (!self.optionId) {
            [SVProgressHUD showErrorWithStatus:@"请至少选择一个技师"];
        } else {
        [XHHttpTool put:url params:nil success:^(id json) {
            [SVProgressHUD showSuccessWithStatus:@"派单成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
        }];
        }

    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

@end


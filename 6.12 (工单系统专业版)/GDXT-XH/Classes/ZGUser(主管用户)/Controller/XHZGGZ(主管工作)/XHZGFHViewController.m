//
//  XHZGFHViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHZGFHViewController.h"
#import "NSString+FontAwesome.h"
#import "XHOrder.h"
#import "XHFooterView.h"
#import "XHOrderCell.h"
#import "XHGuaDanCenterCell.h"
#import "XHInstructionCell.h"
#import "XHFuHeDetailCell.h"
#import "XHConst.h"
#import "XHOrderFrame.h"
#import "XHHttpTool.h"
#import "MJExtension.h"
#import "XHDepartment.h"
#import "XHOption.h"
#import "SVProgressHUD.h"
#import "XHOptionUpload.h"

@interface XHZGFHViewController ()<UITableViewDelegate, UITableViewDelegate, XHFooterViewDelegate, XHGuaDanCenterCellDelegate>
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UITableView *FUHETableview;

@property (nonatomic, copy) NSString *optionId;
@property (nonatomic, copy) NSString *optionName;

@end

@implementation XHZGFHViewController
static NSString *ID1 = @"XHOrderDetailCell";
static NSString *ID2 = @"XHChooseCell";
static NSString *ID3 = @"XHInstructionCell";
static NSString *ID4 = @"XHFuHeDetailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupTableView
{
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    [self.FUHETableview registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID1];
    [self.FUHETableview registerNib:[UINib nibWithNibName:@"XHFuHeDetailCell" bundle:nil] forCellReuseIdentifier:ID4];
    [self.FUHETableview registerNib:[UINib nibWithNibName:@"XHGuaDanCenterCell" bundle:nil] forCellReuseIdentifier:ID2];
    
    [self.FUHETableview registerNib:[UINib nibWithNibName:@"XHInstructionCell" bundle:nil] forCellReuseIdentifier:ID3];
    
    
    
    XHFooterView *footerView = [XHFooterView footerView];
    footerView.btnTitle = @"复核";
    footerView.delegate = self;
    self.FUHETableview.tableFooterView = footerView;
}




- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        XHOrderCell *firstCell = [self.FUHETableview dequeueReusableCellWithIdentifier:ID1];
        firstCell.orderFrame = self.mOrderFrame;
        XHOrder *order =  self.mOrderFrame.order;
        order.imageUrl = @"he_con";
        firstCell.jieDanBtn.hidden = YES;
        firstCell.lingLiaoBtn.hidden = YES;
        cell = firstCell;
    }else if (indexPath.section == 1){
        XHFuHeDetailCell *thirdCell = [self.FUHETableview dequeueReusableCellWithIdentifier:ID4];
        thirdCell.detailOrder = self.fuheDetailOrder;
        thirdCell.remarkOrder = self.remarkOrder;
        cell = thirdCell;
    }else if (indexPath.section == 2){
        XHGuaDanCenterCell *secondCell = [self.FUHETableview dequeueReusableCellWithIdentifier:ID2];
        secondCell.optionUrl = self.optionUrl;
//        XHDepartment *confirm = self.confirmOptions[indexPath.row];
        secondCell.delegate = self;
        cell = secondCell;
    }else {
        XHInstructionCell *forthCell = [self.FUHETableview dequeueReusableCellWithIdentifier:ID3];
        cell = forthCell;
        self.indexPath = indexPath;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        self.mOrderFrame.order.opened = !self.mOrderFrame.order.isOpened;
        [UIView animateWithDuration:0.7 animations:^{
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return (self.mOrderFrame.order.isOpened ? self.mOrderFrame.cellHeight - 50 : 200);
        
    }else if(indexPath.section == 1){
        return 90;
    } else if (indexPath.section == 2) {
        return 90;
    } else{
        return 200;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"工单详情";
    }else if (section == 1){
        return @"复核详情";
    }else if(section ==2){
        return @"复核选项";
    } else {
        return @"复核结论";
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor = [UIColor redColor];
}

#pragma mark - XHGuaDanFooterViewDelegate
- (void)guaDanFooterViewOptionButtonDidClick:(XHGuaDanCenterCell *)footerView Option:(XHOption *)option {
    _optionId = option.objectId;
    _optionName = option.name;
}


#pragma mark - XHFooterViewDelegate
- (void)footerViewButtonDidClick:(XHFooterView *)footerView
{
    XHInstructionCell *cell = (XHInstructionCell *)[self.FUHETableview cellForRowAtIndexPath:self.indexPath];
    NSString *url = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/confirm",self.workOrderId];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认复核？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (!self.optionId) {
            [SVProgressHUD showErrorWithStatus:@"请至少选择一个复核选项"];
        } else {
            XHOptionUpload *optionUpload = [[XHOptionUpload alloc]init];
//            XHOption *selectedOption = self.options[self.selectedButton.tag];
            XHOption *option = [[XHOption alloc]init];
            option.name = _optionName;
            option.objectId = _optionId;
            optionUpload.option = option;
            optionUpload.remark = cell.instructionmentTextView.text;
            [XHHttpTool put:url params:optionUpload.mj_keyValues success:^(id json) {
                [SVProgressHUD showSuccessWithStatus:@"复核成功"];
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
- (NSString *)covertToDateStringFromString:(NSString *)Str
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[Str longLongValue]/1000.0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}



@end


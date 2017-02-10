//
//  XHSearchResultViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/4/19.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSearchResultViewController.h"
#import "XHOrderCell.h"
#import "NSString+FontAwesome.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "MJExtension.h"
#import "XHOrder.h"
#import "SVProgressHUD.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"
#import "XHOrderFrame.h"
#import "SVProgressHUD.h"
static NSString *ID=@"xhresultCell";
@interface XHSearchResultViewController () <XHOrderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
//@property (strong, nonatomic) IBOutlet UILabel *noDataLabel;
@property (nonatomic, strong) NSMutableArray *DjdOrderFrames;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger totalCount;
@end

@implementation XHSearchResultViewController
- (NSMutableArray *)DjdOrderFrames
{
    if (!_DjdOrderFrames) {
        _DjdOrderFrames = [[NSMutableArray alloc]init];
    }
    return _DjdOrderFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.myTableView registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID];
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.myTableView.mj_header beginRefreshing];
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
}

- (void)loadNewData
{
    self.currentPage = 1;
    [self loadDjdOrders];
}
- (void)loadMoreData
{
    self.currentPage ++;
    [self loadDjdOrders];
}
- (void)loadDjdOrders
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNo"] = [NSString stringWithFormat:@"%d",self.currentPage];
    params[@"pageSize"] = @"5";
    if (self.gdlxId) {
        params[@"type"] = self.gdlxId;
    }
    if (self.equipmentId) {
        params[@"equipment"] = self.equipmentId;
    }
    if (self.statusId) {
        params[@"status"] = self.statusId;
    }
    if (self.emergencyId) {
        params[@"emergencyDegree"] = self.emergencyId;
    }
    if (self.departmentId) {
        params[@"department"] = self.departmentId;
    }
    if (self.startDate) {
        params[@"startDate"] = self.startDate;
    }
    if (self.endDate) {
        params[@"endDate"] = self.endDate;
    }
    [XHHttpTool get:SearchResultUrl params:params success:^(NSDictionary *json) {
        [SVProgressHUD dismiss];
        if (self.currentPage == 1) { // 清除之前的旧数据
            [self.DjdOrderFrames removeAllObjects];
        }
        self.totalCount = [json[@"totalElements"] integerValue];
        NSArray *arr = json[@"content"];
        for (int i = 0; i < arr.count; i++) {
            XHOrder *order = [XHOrder mj_objectWithKeyValues:arr[i]];
            XHOrderFrame *orderFrame = [[XHOrderFrame alloc]init];
            orderFrame.order = order;
            [self.DjdOrderFrames addObject:orderFrame];
        }

        if (self.DjdOrderFrames.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"暂无数据" maskType:SVProgressHUDMaskTypeBlack];
         }
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)XHOrderCell:(XHOrderCell *)cell callTelClickButton:(NSInteger)index {
    XHOrderFrame *orderFrame = self.DjdOrderFrames[index];
    XHOrder *order = orderFrame.order;
    NSString *message = [NSString stringWithFormat:@"确认拨打此电话？Tel:%@",order.callNumber];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",order.callNumber]]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)XHOrderCell:(XHOrderCell *)cell callTelTwoClickButton:(NSInteger)index {
    XHOrderFrame *orderFrame = self.DjdOrderFrames[index];
    XHOrder *order = orderFrame.order;
    if (order.receiverPhone) {
        NSString *message = [NSString stringWithFormat:@"确认拨打此电话？Tel:%@",order.receiverPhone];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",order.callNumber]]];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [SVProgressHUD showInfoWithStatus:@"此用户暂时没有记录手机号"];
    }
    
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.DjdOrderFrames.count == self.totalCount) {
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.myTableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self.DjdOrderFrames.count;
}
- (XHOrderCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[XHOrderCell alloc]init];
    }
    cell.lingLiaoBtn.hidden = YES;
    cell.jieDanBtn.hidden = YES;
    cell.delegate = self;
    cell.bxryBtn.tag = indexPath.row;
    cell.receiverButton.tag = indexPath.row;
    cell.orderFrame = self.DjdOrderFrames[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHOrderFrame *orderFrame = self.DjdOrderFrames[indexPath.row];
    XHOrder *DjdOrder = orderFrame.order;
    return DjdOrder.isOpened ? orderFrame.cellHeight - 50 : 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XHOrderFrame *orderFrame = self.DjdOrderFrames[indexPath.row];
    XHOrder *DjdOrder = orderFrame.order;
    DjdOrder.opened = !DjdOrder.isOpened;
    [UIView animateWithDuration:0.7 animations:^{
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

@end

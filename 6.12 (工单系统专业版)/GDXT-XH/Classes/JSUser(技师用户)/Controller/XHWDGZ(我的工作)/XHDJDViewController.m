//
//  XHDJDViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHDJDViewController.h"
#import "XHMyJobViewController.h"
#import "XHOrderCell.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "MJExtension.h"
#import "XHOrder.h"
#import "SVProgressHUD.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"
#import "XHOrderFrame.h"
static NSString *ID = @"xhjdCell";
@interface XHDJDViewController ()<UITableViewDelegate,UITableViewDataSource,XHOrderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *DJDTableView;
@property (nonatomic, strong) NSMutableArray *DjdOrderFrames;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger  totalCount;
/** 被选中的orderFrame */
@property (nonatomic, strong) XHOrderFrame *selectedOrderFrame;
@property (weak, nonatomic) IBOutlet UILabel *noDataLable;


@end

@implementation XHDJDViewController
extern XHMyJobViewController *mMyJobVc;

- (NSMutableArray *)DjdOrderFrames
{
    if (!_DjdOrderFrames) {
        _DjdOrderFrames = [[NSMutableArray alloc]init];
    }
    return _DjdOrderFrames;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
 }
- (void)setupTableView
{
    self.DJDTableView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    [self.DJDTableView registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID];
    self.DJDTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.DJDTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.DJDTableView.mj_header beginRefreshing];
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
    //显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNo"] = [NSString stringWithFormat:@"%d",self.currentPage];
    params[@"pageSize"] = @"5";
    [XHHttpTool get:DjdOrderUrl params:params success:^(NSDictionary *json) {
        [SVProgressHUD dismiss];
        if (self.currentPage == 1) { // 清除之前的旧数据
            [self.DjdOrderFrames removeAllObjects];
        }
        self.totalCount = [json[@"totalElements"] integerValue];
        [XHNotificationCenter postNotificationName:XHDJDOrderCountDidChangeNotification object:nil userInfo:@{XHDJDOrderCount: [NSString stringWithFormat:@"%lu",self.totalCount]}];
        [self.DJDTableView.mj_header endRefreshing];
        [self.DJDTableView.mj_footer endRefreshing];
        NSArray *arr = json[@"content"];
        for (int i = 0; i < arr.count; i++) {
            XHOrder *order = [XHOrder mj_objectWithKeyValues:arr[i][@"workOrderInfo"]];
            XHOrderFrame *orderFrame = [[XHOrderFrame alloc]init];
            orderFrame.order = order;
            [self.DjdOrderFrames addObject:orderFrame];
        }
        if (self.DjdOrderFrames.count == 0) {
            self.noDataLable.hidden = NO;
        }else{
            self.noDataLable.hidden = YES;
        }
        [self showOrderCount:self.totalCount];
           [self.DJDTableView reloadData];
    } failure:^(NSError *error) {
        [self.DJDTableView.mj_header endRefreshing];
        [self.DJDTableView.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"加载数据失败"];
    }];
 
}
- (void)showOrderCount:(NSInteger)count
{
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = XHOrderCountColor;
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 40;
    
    // 2.设置其他属性
    label.text = [NSString stringWithFormat:@"共%ld条记录", count];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 3.添加
    label.y = - label.height;
    [self.view addSubview:label];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 0.5; // 动画的时间
    [UIView animateWithDuration:duration animations:^{

        label.transform = CGAffineTransformMakeTranslation(0, 35);
        
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 0.5; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
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


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.DjdOrderFrames.count == self.totalCount) {
        [self.DJDTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.DJDTableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self.DjdOrderFrames.count;
}



- (XHOrderCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.lingLiaoBtn.hidden = YES;
    cell.bxryBtn.tag = indexPath.row;
    cell.receiverButton.tag = indexPath.row;
    XHOrderFrame *orderFrame = self.DjdOrderFrames[indexPath.row];
    XHOrder *order = orderFrame.order;
    order.buttonTitle = @"接单";
    order.imageUrl = @"pai_con";
    cell.orderFrame = orderFrame;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHOrderFrame *orderFrame = self.DjdOrderFrames[indexPath.row];
    return orderFrame.order.isOpened ? orderFrame.cellHeight : 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XHOrderFrame *DjdOrderFrame = self.DjdOrderFrames[indexPath.row];
    DjdOrderFrame.order.opened = !DjdOrderFrame.order.isOpened;
    [UIView animateWithDuration:0.7 animations:^{
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
}
#pragma  mark - XHOrderCellDelegate
- (void)DJDTableViewCell:(XHOrderCell *)cell didClickButton:(XHDJDTableViewButton)button;
{
    self.selectedOrderFrame = cell.orderFrame;
    if (button == XHDJDTableViewButtonCaozuo) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定接单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertView show];
      }
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //接单url
        NSString *url = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/receive",self.selectedOrderFrame.order.workOrderId];
        [XHHttpTool put:url params:nil success:^(id json) {
            [SVProgressHUD showSuccessWithStatus:@"接单成功"];
            [self.DJDTableView.mj_header beginRefreshing];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"接单失败"];
        }];
    }
}

@end

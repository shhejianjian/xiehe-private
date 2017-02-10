//
//  XHJDViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHJDViewController.h"
#import "XHMyJobViewController.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "MJExtension.h"
#import "XHOrder.h"
#import "XHOrderCell.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "UIView+Extension.h"
#import "XHOrderFrame.h"
static NSString *ID=@"xhjdCell";
@interface XHJDViewController ()<UITableViewDelegate,UITableViewDataSource,XHOrderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *JDTableView;
@property (nonatomic, strong) NSMutableArray *JDOrderFrames;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger  totalCount;
@property (weak, nonatomic) IBOutlet UILabel *noDataLable;

@end

@implementation XHJDViewController
- (NSMutableArray *)JDOrderFrames
{
    if (!_JDOrderFrames) {
        _JDOrderFrames = [[NSMutableArray alloc]init];
    }
    return _JDOrderFrames;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
 }
- (void)setupTableView
{
    self.JDTableView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    [self.JDTableView registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID];
    self.JDTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.JDTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.JDTableView.mj_header beginRefreshing];
}
- (void)loadNewData
{
    self.currentPage = 1;
    [self loadJDOrders];
}
- (void)loadMoreData
{
    self.currentPage ++;
    [self loadJDOrders];
}
- (void)loadJDOrders {
    //显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNo"] = [NSString stringWithFormat:@"%d",self.currentPage];
    params[@"pageSize"] = @"5";
    [XHHttpTool get:CompleteOrderUrl params:params success:^(id json) {
        [SVProgressHUD dismiss];
        if (self.currentPage == 1) { // 清除之前的旧数据
            [self.JDOrderFrames removeAllObjects];
        }
        self.totalCount = [json[@"totalElements"] integerValue];
        [XHNotificationCenter postNotificationName:XHJDOrderCountDidChangeNotification object:nil userInfo:@{XHJDOrderCount:[NSString stringWithFormat:@"%lu",(long)self.totalCount]}];

        [self.JDTableView.mj_header endRefreshing];
        [self.JDTableView.mj_footer endRefreshing];
        NSArray *arr = json[@"content"];
        for (int i = 0; i < arr.count; i++) {
            XHOrder *order = [XHOrder mj_objectWithKeyValues:arr[i][@"workOrderInfo"]];
            XHOrderFrame *orderFrame = [[XHOrderFrame alloc]init];
            orderFrame.order = order;
            [self.JDOrderFrames addObject:orderFrame];
        }
        if (self.JDOrderFrames.count == 0) {
            self.noDataLable.hidden = NO;
        }else{
            self.noDataLable.hidden = YES;
        }
        [self showOrderCount:self.totalCount];
        [self.JDTableView reloadData];
    } failure:^(NSError *error) {
        [self.JDTableView.mj_header endRefreshing];
        [self.JDTableView.mj_footer endRefreshing];
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
    label.text = [NSString stringWithFormat:@"共%ld条记录", (long)count];
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
    XHOrderFrame *orderFrame = self.JDOrderFrames[index];
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
    XHOrderFrame *orderFrame = self.JDOrderFrames[index];
    XHOrder *order = orderFrame.order;
    if (order.receiverPhone) {
        NSString *message = [NSString stringWithFormat:@"确认拨打此电话？Tel:%@",order.receiverPhone];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",order.receiverPhone]]];
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
    if (self.JDOrderFrames.count == self.totalCount) {
        [self.JDTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.JDTableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self.JDOrderFrames.count;
}


- (XHOrderCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    XHOrderFrame *orderFrame = self.JDOrderFrames[indexPath.row];
    XHOrder *order = orderFrame.order;
    if (order.completeTime.length) {
        order.imageUrl = @"Jdan_con";
    }else{
        order.imageUrl = @"he_con";
    }
    cell.lingLiaoBtn.hidden = YES;
    cell.jieDanBtn.hidden = YES;
    cell.orderFrame = orderFrame;
    cell.delegate = self;
    cell.bxryBtn.tag = indexPath.row;
    cell.receiverButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHOrderFrame *orderFrame = self.JDOrderFrames[indexPath.row];
    return (orderFrame.order.isOpened ? (orderFrame.cellHeight - 50) : 200);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XHOrderFrame *orderFrame = self.JDOrderFrames[indexPath.row];
    orderFrame.order.opened = !orderFrame.order.isOpened;
    [UIView animateWithDuration:0.7 animations:^{
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

@end

//
//  XHZGYGQViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/17.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHZGYGQViewController.h"
#import "XHZGJobViewController.h"
#import "XHOrderCell.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "MJExtension.h"
#import "XHOrder.h"
#import "SVProgressHUD.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"
#import "XHZGPDViewController.h"
#import "XHOrderFrame.h"
static NSString *ID=@"xhzgygqCell";
//#define  selectedYJDOrderFrame self.DjdOrderFrames[self.ygqTableView.indexPathForSelectedRow.row]

@interface XHZGYGQViewController ()<UITableViewDelegate,UITableViewDataSource,XHOrderCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *ygqTableView;
@property (strong, nonatomic) IBOutlet UILabel *noDataLabel;
@property (nonatomic, strong) NSMutableArray *DjdOrderFrames;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger  totalCount;
@end


@implementation XHZGYGQViewController
extern XHZGJobViewController *mZgJobVc;

- (NSMutableArray *)DjdOrderFrames
{
    if (!_DjdOrderFrames) {
        _DjdOrderFrames = [[NSMutableArray alloc]init];
    }
    return _DjdOrderFrames;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.ygqTableView registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID];
    self.ygqTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.ygqTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.ygqTableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
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
    
    [XHHttpTool get:ZGYGQOrderUrl params:params success:^(NSDictionary *json) {
        [SVProgressHUD dismiss];

        NSLog(@"%@",json);
        if (self.currentPage == 1) { // 清除之前的旧数据
            [self.DjdOrderFrames removeAllObjects];
        }
        
        self.totalCount = [json[@"totalElements"] integerValue];
        [XHNotificationCenter postNotificationName:XHZGYGQOrderCountDidChangeNotification object:nil userInfo:@{XHZGYGQOrderCount: [NSString stringWithFormat:@"%lu",self.totalCount]}];
        NSArray *arr = json[@"content"];
        for (int i = 0; i < arr.count; i++) {
            XHOrder *order = [XHOrder mj_objectWithKeyValues:arr[i][@"workOrderInfo"]];
            XHOrderFrame *orderFrame = [[XHOrderFrame alloc]init];
            orderFrame.order = order;
            [self.DjdOrderFrames addObject:orderFrame];
        }
        
        if (self.DjdOrderFrames.count == 0) {
            self.noDataLabel.hidden = NO;
        }else{
            self.noDataLabel.hidden = YES;
        }
        if (_currentPage == 1) {
            [self showOrderCount:_totalCount];
        }
        [self.ygqTableView.mj_header endRefreshing];
        [self.ygqTableView.mj_footer endRefreshing];
        [self.ygqTableView reloadData];
    } failure:^(NSError *error) {
        [self.ygqTableView.mj_header endRefreshing];
        [self.ygqTableView.mj_footer endRefreshing];
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

#pragma mark - XHOrderCellDelegate
- (void)DJDTableViewCell:(XHOrderCell *)cell didClickButton:(XHDJDTableViewButton)button {
    if (button == XHDJDTableViewButtonCaozuo) {
        XHZGPDViewController *paiDanVc = [[XHZGPDViewController alloc]init];
        paiDanVc.orderFrame = cell.orderFrame;
        paiDanVc.orderFrame.order.opened = NO;
        paiDanVc.workOrderId = paiDanVc.orderFrame.order.workOrderId;
        paiDanVc.optionUrl = [NSString stringWithFormat:@"api/v1/hems/workOrder/artificer?workOrderId=%@",paiDanVc.orderFrame.order.workOrderId];
        [mZgJobVc.navigationController pushViewController:paiDanVc animated:YES];
    }
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
    if (self.DjdOrderFrames.count == self.totalCount) {
        [self.ygqTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.ygqTableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self.DjdOrderFrames.count;
}


- (XHOrderCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[XHOrderCell alloc]init];
    }
    cell.delegate = self;
    cell.lingLiaoBtn.hidden = YES;
    cell.bxryBtn.tag = indexPath.row;
    cell.receiverButton.tag = indexPath.row;
//    [cell.jieDanBtn setTitle:@"派单" forState:UIControlStateNormal];
    XHOrderFrame *orderFrame = self.DjdOrderFrames[indexPath.row];
    XHOrder *order = orderFrame.order;
    order.imageUrl = @"gua_icon";
    order.buttonTitle = @"派单";
    cell.orderFrame = orderFrame;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XHOrderFrame *orderFrame = self.DjdOrderFrames[indexPath.row];
    return orderFrame.order.isOpened ? orderFrame.cellHeight : 240;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XHOrderFrame *orderFrame = self.DjdOrderFrames[indexPath.row];
    orderFrame.order.opened = !orderFrame.order.isOpened;
    [UIView animateWithDuration:0.7 animations:^{
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

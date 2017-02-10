//
//  XHYellowWarnViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/17.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHYellowWarnViewController.h"
#import "XHYJMainViewController.h"
#import "XHWarnDetailViewController.h"
#import "XHWarnCell.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "MJExtension.h"
#import "XHWarn.h"
#import "SVProgressHUD.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"
static NSString *ID=@"warnCell";

@interface XHYellowWarnViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *yellowWarnTableview;
@property (nonatomic, strong) NSMutableArray *DjdOrders;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger  totalCount;
@property (weak, nonatomic) IBOutlet UILabel *noDataLable;
@end

@implementation XHYellowWarnViewController
- (NSMutableArray *)DjdOrders
{
    if (!_DjdOrders) {
        _DjdOrders = [[NSMutableArray alloc]init];
    }
    return _DjdOrders;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.yellowWarnTableview registerNib:[UINib nibWithNibName:@"XHWarnCell" bundle:nil] forCellReuseIdentifier:ID];
    self.yellowWarnTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.yellowWarnTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.yellowWarnTableview.mj_header beginRefreshing];
    
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
    params[@"pageSize"] = @"8";
    
    [XHHttpTool get:YellowWarnOrderUrl params:params success:^(NSDictionary *json) {
        [SVProgressHUD dismiss];
        if (self.currentPage == 1) { // 清除之前的旧数据
            [self.DjdOrders removeAllObjects];
        }
        
        self.totalCount = [json[@"totalElements"] integerValue];
        [XHNotificationCenter postNotificationName:XHYellowWarnOrderCountDidChangeNotification object:nil userInfo:@{XHYellowWarnOrderCount: [NSString stringWithFormat:@"%lu",self.totalCount]}];
        
        
        NSArray *arr = [XHWarn mj_objectArrayWithKeyValuesArray:json[@"content"]];
        for (XHWarn *redWarn in arr) {
            [self.DjdOrders addObject:redWarn];
        }
        
        if (self.DjdOrders.count == 0) {
            self.noDataLable.hidden = NO;
        }else{
            self.noDataLable.hidden = YES;
        }
        if (_currentPage == 1) {
            [self showOrderCount:_totalCount];
        }
        [self.yellowWarnTableview.mj_header endRefreshing];
        [self.yellowWarnTableview.mj_footer endRefreshing];
        [self.yellowWarnTableview reloadData];
    } failure:^(NSError *error) {
        [self.yellowWarnTableview.mj_header endRefreshing];
        [self.yellowWarnTableview.mj_footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络不稳定,请稍后再试"];
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

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.DjdOrders.count == self.totalCount) {
        [self.yellowWarnTableview.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.yellowWarnTableview.mj_footer.state = MJRefreshStateIdle;
    }
    return self.DjdOrders.count;
}
- (XHWarnCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHWarnCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[XHWarnCell alloc]init];
    }
    cell.yellowWarn = self.DjdOrders[indexPath.row];

    cell.titleLabel.textColor = XHYeollowColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XHWarn *warn = self.DjdOrders[indexPath.row];
    XHWarnDetailViewController *redDetailVc = [[XHWarnDetailViewController alloc]init];
    redDetailVc.workOrderId = warn.workOrderId;
    [self.navigationController pushViewController:redDetailVc animated:YES];
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

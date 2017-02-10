//
//  XHOrderSummaryViewController.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/19.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHOrderSummaryViewController.h"
#import "NSString+FontAwesome.h"
#import "XHSumSecondCell.h"
#import "XHSumThirdCell.h"
#import "XHSumFirstCell.h"
#import "XHConst.h"
#import "XHSumDropdownMenu.h"
#import "XHMenuViewController.h"
#import "UIView+Extension.h"
#import "XHHttpTool.h"
#import "XHSummary.h"
#import "MJExtension.h"
#import "XHSubSummary.h"
@interface XHOrderSummaryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *recentBtn;
@property (weak, nonatomic) IBOutlet UITableView *sumTableView;
@property (nonatomic, strong) XHSumDropdownMenu *menu;
@property (nonatomic, strong) XHSummary *summary;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSMutableArray *categories;
@end

@implementation XHOrderSummaryViewController
- (NSMutableArray *)categories
{
    if (!_categories) {
        _categories = [NSMutableArray array];
    }
    return _categories;
}
static NSString *ID1 = @"XHSumSecondCell";
static NSString *ID2 = @"XHSumThirdCell";
static NSString *ID3 = @"XHSumFirstCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerNib];
    [self loadSummaryData];
   }
- (void)registerNib
{
    [self.sumTableView registerNib:[UINib nibWithNibName:@"XHSumFirstCell" bundle:nil] forCellReuseIdentifier:ID1];
    [self.sumTableView registerNib:[UINib nibWithNibName:@"XHSumSecondCell" bundle:nil] forCellReuseIdentifier:ID2];
    [self.sumTableView registerNib:[UINib nibWithNibName:@"XHSumThirdCell" bundle:nil] forCellReuseIdentifier:ID3];
    self.sumTableView.bounces = NO;
}
- (void)loadSummaryData
{
    [self.categories removeAllObjects];
 [XHHttpTool get:summaryDayUrl params:nil success:^(id json) {
     NSArray *CategoryArr = json[@"categories"];
     for (NSString *category in CategoryArr) {
         NSString *dateCategory = [category substringFromIndex:5];
         [self.categories addObject:dateCategory];
     }
     NSArray *categoryArr = json[@"categories"];
     self.chartData = @[json[@"series"][@"total"],json[@"series"][@"complete"],self.categories];
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
     params[@"startDate"] = categoryArr.firstObject;
     params[@"endDate"] = categoryArr.lastObject;
     [XHHttpTool get:summaryUrl params:params success:^(id json) {
         self.summary = [XHSummary mj_objectWithKeyValues:json];
         [self.sumTableView reloadData];
     } failure:^(NSError *error) {
         XHLog(@"汇总失败%@",error);
     }];
 } failure:^(NSError *error) {
       XHLog(@"汇总每天失败%@",error);
 }];
}
- (void)setupUI
{
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    self.recentBtn.layer.borderWidth = 1.0f;
    self.recentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnRecentClick:(id)sender {
    // 1.创建下拉菜单
    self.menu = [XHSumDropdownMenu menu];

    // 2.设置内容
    XHMenuViewController *vc = [[XHMenuViewController alloc] init];
    vc.view.height = 135;
    vc.view.width = 100;
    self.menu.contentController = vc;
    
    // 3.显示
        [self.menu showFrom:self.recentBtn];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 监听周被点击
    [XHNotificationCenter addObserver:self selector:@selector(weekDidClick) name:XHSumMenuWeekDidClickNotification object:nil];
    // 监听月被点击
    [XHNotificationCenter addObserver:self selector:@selector(monthDidClick) name:XHSumMenuMonthDidClickNotification object:nil];
    // 监听年被点击
    [XHNotificationCenter addObserver:self selector:@selector(yearDidClick) name:XHSumMenuYearDidClickNotification object:nil];
}
- (void)weekDidClick
{
    NSLog(@"weekDidClick");
    [self.menu dismiss];

}
- (void)monthDidClick
{
    NSLog(@"monthDidClick");
    [self.menu dismiss];
}
- (void)yearDidClick
{
    NSLog(@"yearDidClick");
    [self.menu dismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XHNotificationCenter removeObserver:self];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      return section == 1 ? 6 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        XHSumFirstCell *firstCell = [self.sumTableView dequeueReusableCellWithIdentifier:ID1];
        firstCell.summary = self.summary;
           cell = firstCell;
    }else if(indexPath.section == 1){
        XHSubSummary *subSummary = self.summary.workOrderStatus;
         XHSumSecondCell *secondCell = [self.sumTableView dequeueReusableCellWithIdentifier:ID2];
        secondCell.pictureLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:30];
        if (indexPath.row == 0) {
            secondCell.titleLabel.text = @"下单";
            secondCell.pictureLabel.text = @"\uf008";
            secondCell.pictureLabel.backgroundColor = XHYJDColor;
            secondCell.gdNumberLabel.text = [NSString stringWithFormat:@"%d项",subSummary.Issue];

        } else if (indexPath.row == 1) {
            secondCell.titleLabel.text = @"工作中";
            secondCell.pictureLabel.text = @"\uf10c";
            secondCell.pictureLabel.backgroundColor = XHGZZColor;
            secondCell.gdNumberLabel.text = [NSString stringWithFormat:@"%d项",subSummary.Arrive];
        } else if (indexPath.row == 2) {
            secondCell.titleLabel.text = @"已结单";
            secondCell.pictureLabel.text = @"\uf108";
            secondCell.pictureLabel.backgroundColor = XHYJDColor;
            secondCell.gdNumberLabel.text = [NSString stringWithFormat:@"%d项",subSummary.Complete];

        } else if (indexPath.row == 3) {
            int unComplete = subSummary.HangUp + subSummary.Arrive + subSummary.Issue + subSummary.Review + subSummary.Receive + subSummary.Distribute;
            secondCell.titleLabel.text = @"未完成";
            secondCell.pictureLabel.text = @"\uf109";
            secondCell.pictureLabel.backgroundColor = XHWWCColor;
            secondCell.gdNumberLabel.text = [NSString stringWithFormat:@"%d项",unComplete];

        } else if (indexPath.row == 4) {
            secondCell.titleLabel.text = @"挂单";
            secondCell.pictureLabel.text = @"\uf107";
            secondCell.pictureLabel.backgroundColor = XHGDColor;
            secondCell.gdNumberLabel.text = [NSString stringWithFormat:@"%d项",subSummary.HangUp];

        } else  {
            secondCell.titleLabel.text = @"需复核";
            secondCell.pictureLabel.text = @"\uf10a";
            secondCell.pictureLabel.backgroundColor = XHXSHColor;
            secondCell.gdNumberLabel.text = [NSString stringWithFormat:@"%d项",subSummary.Review];
           }
        cell = secondCell;
    }else{
          XHSumThirdCell *thirdCell=[tableView dequeueReusableCellWithIdentifier:ID3];
        thirdCell.chartData = self.chartData;
            cell = thirdCell;
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    }else if(indexPath.section == 1){
        return 80;
    }else{
       return 380;
    }
}
@end

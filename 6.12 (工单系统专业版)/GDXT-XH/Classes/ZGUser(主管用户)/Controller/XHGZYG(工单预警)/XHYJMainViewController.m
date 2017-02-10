//
//  XHYJMainViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/23.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHYJMainViewController.h"
#import "XHRedWarnViewController.h"
#import "XHYellowWarnViewController.h"
#import "XHLeftCell.h"
#import "CDRTranslucentSideBar.h"
#import "NSString+FontAwesome.h"
#import "XHConst.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeScanViewController.h"
#import "QRCodeGenerator.h"
#import "XHGDCXViewController.h"
#import "XHLoginViewController.h"
#import "XHAssistViewController.h"
#import "XHVoiceViewController.h"
#import "XHJieDanViewController.h"
#import "XHGuaDanViewController.h"
#import "XHVideoViewController.h"
#import "UIView+Extension.h"
#import "XYTitleButton.h"
#import "AFNetWorking.h"
#import "SVProgressHUD.h"
#import "XHOrderSummaryViewController.h"
#import "XHZGJobViewController.h"
static NSString *ID=@"leftViewCell";
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface XHYJMainViewController ()<UIScrollViewDelegate,CDRTranslucentSideBarDelegate,UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *leftViewBtn;
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;
@property (nonatomic, copy) UIView *bgView;
@property (nonatomic, strong)NSArray *titles;
@property (nonatomic, strong)NSArray *controllers;
@property (nonatomic, strong)UITableView *leftTableView;
/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;
/** 顶部的所有按钮 */
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation XHYJMainViewController
extern XHYJMainViewController *mYjMainVc;

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self upDateUI];
    
    // 初始化子控制器
    [self setupChildVces];
    
    // 设置顶部的标签栏
    [self setupTitlesView];
    
    // 底部的scrollView
    [self setupContentView];
    
}

- (void)upDateUI {
    
    self.sideBar = [[CDRTranslucentSideBar alloc] init];
    self.sideBar.sideBarWidth = [UIScreen mainScreen].bounds.size.width * 0.8;
    self.sideBar.delegate = self;
    self.sideBar.tag = 0;
    
    _leftTableView = [[UITableView alloc]init];
    _leftTableView.backgroundColor = XHLeftColor;
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.bounces = NO;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftTableView registerNib:[UINib nibWithNibName:@"XHLeftCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.sideBar setContentViewInSideBar:_leftTableView];
    
    self.leftViewBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    [self.leftViewBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconReorder] forState:UIControlStateNormal];
    [self.leftViewBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconReorder] forState:UIControlStateSelected];
}
/**
 * 初始化子控制器
 */
- (void)setupChildVces
{
    XHRedWarnViewController *DJDVC = [[XHRedWarnViewController alloc] init];
    DJDVC.title = @"红色预警";
    [self addChildViewController:DJDVC];
    
    XHYellowWarnViewController *YJDVC = [[XHYellowWarnViewController alloc] init];
    YJDVC.title = @"黄色预警";
    [self addChildViewController:YJDVC];
}

/**
 * 设置顶部的标签栏
 */
- (void)setupTitlesView
{
    
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = XHGlobalColor;
    titlesView.width = screenWidth;
    titlesView.height = 40;
    titlesView.y = 64;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor orangeColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    CGFloat width = titlesView.width / self.childViewControllers.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        XYTitleButton *button = [[XYTitleButton alloc] init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button setTitleColor:XHWhiteColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [titlesView addSubview:button];
        
        // 默认点击了第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            self.indicatorView.width = button.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    
    [titlesView addSubview:indicatorView];
}

- (void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = XHHeaderViewColor;
    contentView.frame = [UIScreen mainScreen].bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    contentView.contentInset = UIEdgeInsetsMake(104, 0, 0, 0);
    contentView.bounces = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [XHNotificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotifications];
}
/**
 * 注册通知
 */
- (void)setupNotifications
{
    // 监听待接单数量改变
    [XHNotificationCenter addObserver:self selector:@selector(RedWarnOrderCountDidChange:) name:XHRedWarnOrderCountDidChangeNotification object:nil];
    // 监听已接单数量改变
    [XHNotificationCenter addObserver:self selector:@selector(YellowWarnOrderCountDidChange:) name:XHYellowWarnOrderCountDidChangeNotification object:nil];
}

- (void)RedWarnOrderCountDidChange:(NSNotification *)notification
{
    XYTitleButton *button = self.buttons[0];
    NSString *count = notification.userInfo[XHRedWarnOrderCount];
    button.countStr = count;
    NSLog(@"待接单数量%@",notification.userInfo[XHRedWarnOrderCount]);
}
- (void)YellowWarnOrderCountDidChange:(NSNotification *)notification
{
    XYTitleButton *button = self.buttons[1];
    button.countStr = notification.userInfo[XHYellowWarnOrderCount];
    NSLog(@"已接单数量%@",notification.userInfo[XHYellowWarnOrderCount]);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.width = scrollView.width;
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}


#pragma mark - CDRTranslucentSideBar
- (IBAction)click:(UIButton *)sender {
    [self.sideBar show];
    [self.leftTableView reloadData];
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated
{
    [self createBackgroundView];
    
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated
{
    [_bgView removeFromSuperview];
}
-(void)createBackgroundView{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.6;
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (XHLeftCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHLeftCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[XHLeftCell alloc]init];
    }
    cell.leftViewLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:25];
    
    if (indexPath.row == 0) {
        cell.leftViewLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:30];
        cell.leftViewLabel.text = @"\uf10c";
        cell.titleLabel.text = @"我的工作";
    } else if (indexPath.row == 1) {
        cell.leftViewLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:30];
        cell.leftViewLabel.text = @"\uf1c0";
        cell.titleLabel.text = @"工单查询";
    } else if (indexPath.row == 2) {
        cell.leftViewLabel.text = @"\uf1f9";
        cell.titleLabel.text = @"工单预警";
    } else if (indexPath.row == 3) {
        cell.leftViewLabel.text = @"\uf130";
        cell.titleLabel.text = @"工单汇总";
    } else if (indexPath.row == 4) {
        cell.leftViewLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:35];
        cell.leftViewLabel.text = @"\uf16d";
        cell.titleLabel.text = @"设备扫码";
    } else if (indexPath.row == 5) {
        cell.leftViewLabel.text = @"\uf1cc";
        cell.titleLabel.text = @"用户登出";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.sideBar dismiss];
    if (indexPath.row == 0) {
        XHZGJobViewController *zgMainVC = [[XHZGJobViewController alloc]init];
        [self.navigationController pushViewController:zgMainVC animated:YES];
    }
    if (indexPath.row == 1) {
        XHGDCXViewController *gdcxVC = [[XHGDCXViewController alloc]init];
        [self.navigationController pushViewController:gdcxVC animated:YES];
    }
    if (indexPath.row == 2) {
        
    }
    if (indexPath.row == 3) {
        XHOrderSummaryViewController *OrderSumVc = [[XHOrderSummaryViewController alloc]init];
        [self.navigationController pushViewController:OrderSumVc animated:YES];
    }
    if (indexPath.row == 4) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
            NSBundle *bundle =[NSBundle mainBundle];
            NSDictionary *info =[bundle infoDictionary];
            NSString *prodName =[info objectForKey:@"CFBundleDisplayName"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法打开相机" message:[NSString stringWithFormat:@"请在用户设置->隐私->相机->%@ 开启相机使用权限",prodName] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else {
            QRCodeScanViewController *qrVC = [[QRCodeScanViewController alloc]initWithNibName:@"QRCodeScanViewController" bundle:nil];
            [self.navigationController pushViewController:qrVC animated:YES];
        }
    }
    if (indexPath.row == 5) {
        [self logOut];
    }
}
- (void)logOut
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"您确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logOff];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)logOff
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:LogoutUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        mYjMainVc = nil;
        [self jumpToVC];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"退出失败"];
    }];
    
}
- (void)jumpToVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
//    CATransition* transition = [CATransition animation];
//    transition.type = kCATransitionPush;//可更改为其他方式
//    transition.subtype = kCATransitionFromLeft;
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"login"] animated:YES];
}


@end

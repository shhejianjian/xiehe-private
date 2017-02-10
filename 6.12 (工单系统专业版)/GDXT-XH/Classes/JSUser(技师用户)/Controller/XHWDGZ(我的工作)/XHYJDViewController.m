//
//  XHYJDViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHYJDViewController.h"
#import "XHMyJobViewController.h"
#import "XHOrderCell.h"
#import "UIViewController+KNSemiModal.h"
#import "XHOperationViewController.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "XHOrder.h"
#import "XHLingLiaoViewController.h"
#import "XHDJDViewController.h"
#import "XHVoiceViewController.h"
#import "XHVideoViewController.h"
#import "XHAssistViewController.h"
#import "QRCodeScanViewController.h"
#import "takePhoto.h"
#import <AVFoundation/AVFoundation.h>
#import "XHJieDanViewController.h"
#import "XHGuaDanViewController.h"
#import "MJRefresh.h"
#import "UIView+Extension.h"
#import "XHPhotoViewController.h"
#import "XHOrderFrame.h"
static NSString *ID=@"xhjdCell";
@interface XHYJDViewController ()<UITableViewDelegate,UITableViewDataSource,XHOrderCellDelegate,XHOperationViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *YJDTableView;
@property (nonatomic, strong) NSMutableArray *YjdOrderFrames;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger  totalCount;
/** 无数据时显示的lable*/
@property (weak, nonatomic) IBOutlet UILabel *noDataLable;
/** 被选中的orderFrame */
@property (nonatomic, strong) XHOrderFrame *selectedOrderFrame;
@end

@implementation XHYJDViewController
extern XHMyJobViewController *mMyJobVc;

- (NSMutableArray *)YjdOrderFrames
{
    if (!_YjdOrderFrames) {
        _YjdOrderFrames = [[NSMutableArray alloc]init];
    }
    return _YjdOrderFrames;
}
- (XHOperationViewController *)operationView
{
    if (!_operationView) {
        _operationView = [[XHOperationViewController alloc]init];
        _operationView.delegate = self;
    }
    return _operationView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [XHNotificationCenter addObserver:self selector:@selector(updateData) name:XHYJDUpdateDateNotification object:nil];

}
- (void)updateData
{
         self.YJDTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [self.YJDTableView.mj_header beginRefreshing];
     }
- (void)dealloc
{
    [XHNotificationCenter removeObserver:self];
}

- (void)setupTableView
{
    self.YJDTableView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    [self.YJDTableView registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID];
    self.YJDTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.YJDTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.YJDTableView.mj_header beginRefreshing];
}
- (void)loadNewData
{
    self.currentPage = 1;
    [self loadYjdOrders];
}
- (void)loadMoreData
{
    self.currentPage ++;
    [self loadYjdOrders];
}
- (void)loadYjdOrders
{
    //显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNo"] = [NSString stringWithFormat:@"%d",self.currentPage];
    params[@"pageSize"] = @"5";
    [XHHttpTool get:ReceiveOrderUrl params:params success:^(id json) {
        [SVProgressHUD dismiss];
        if (self.currentPage == 1) { // 清除之前的旧数据
            [self.YjdOrderFrames removeAllObjects];
        }
        
        self.totalCount = [json[@"totalElements"] integerValue];
        [XHNotificationCenter postNotificationName:XHYJDOrderCountDidChangeNotification object:nil userInfo:@{XHYJDOrderCount:[NSString stringWithFormat:@"%lu",self.totalCount]}];

        [self.YJDTableView.mj_header endRefreshing];
        [self.YJDTableView.mj_footer endRefreshing];
        NSArray *arr = json[@"content"];
              for (int i = 0; i < arr.count; i++) {
            XHOrder *order = [XHOrder mj_objectWithKeyValues:arr[i][@"workOrderInfo"]];
            XHOrderFrame *orderFrame = [[XHOrderFrame alloc]init];
            orderFrame.order = order;
            [self.YjdOrderFrames addObject:orderFrame];
        }
        if (self.YjdOrderFrames.count == 0) {
            self.noDataLable.hidden = NO;
        }else{
            self.noDataLable.hidden = YES;
        }
        [self showOrderCount:self.totalCount];
        [self.YJDTableView reloadData];
    } failure:^(NSError *error) {
        [self.YJDTableView.mj_header endRefreshing];
        [self.YJDTableView.mj_footer endRefreshing];
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

#pragma mark - XHOrderCellDelegate
- (void)DJDTableViewCell:(XHOrderCell *)cell didClickButton:(XHDJDTableViewButton)button
{
    self.selectedOrderFrame = cell.orderFrame;
    if (button == XHDJDTableViewButtonLingLiao) {
        XHLingLiaoViewController *lingliaoVc = [[XHLingLiaoViewController alloc]init];
        lingliaoVc.notiStr = @"YJD";
        lingliaoVc.mOrderFrame = self.selectedOrderFrame;
        lingliaoVc.mOrderFrame.order.opened = NO;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:lingliaoVc animated:NO completion:nil];
    }else {
        if ([self.selectedOrderFrame.order.statusTag isEqualToString:@"Receive"]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定到达?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alertView show];
        }else {
            UIImageView * bgimgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]];
            [self presentSemiViewController:self.operationView withOptions:@{
                                                                             KNSemiModalOptionKeys.pushParentBack    : @(YES),
                                                                             KNSemiModalOptionKeys.animationDuration : @(0.5),
                                                                             KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                             KNSemiModalOptionKeys.backgroundView:bgimgv
                                                                             }];
        }

    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //接单url
        NSString *url = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/arrive",self.selectedOrderFrame.order.workOrderId];
        [XHHttpTool put:url params:nil success:^(id json) {
            [SVProgressHUD showSuccessWithStatus:@"到达!"];
            [self.YJDTableView.mj_header beginRefreshing];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"到达失败"];
        }];
    }
}
- (void)XHOrderCell:(XHOrderCell *)cell callTelClickButton:(NSInteger)index {
    XHOrderFrame *orderFrame = self.YjdOrderFrames[index];
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
    XHOrderFrame *orderFrame = self.YjdOrderFrames[index];
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


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.YjdOrderFrames.count == self.totalCount) {
        [self.YJDTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.YJDTableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self.YjdOrderFrames.count;
}


- (XHOrderCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    XHOrderFrame *orderFrame = self.YjdOrderFrames[indexPath.row];
    XHOrder *order = orderFrame.order;
    order.imageUrl = @"jie_icon";
    if ([order.statusTag isEqualToString:@"Receive"]) {
        order.buttonTitle = @"到达";
    }else{
        order.buttonTitle = @"操作";
    }
    cell.orderFrame = orderFrame;
    cell.delegate = self;
    cell.bxryBtn.tag = indexPath.row;
    cell.receiverButton.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHOrderFrame *orderFrame  = self.YjdOrderFrames[indexPath.row];
    XHOrder *order = orderFrame.order;
    return order.isOpened ? orderFrame.cellHeight : 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XHOrderFrame *orderFrame = self.YjdOrderFrames[indexPath.row];
    XHOrder *order = orderFrame.order;
    order.opened = !order.isOpened;
    [UIView animateWithDuration:0.7 animations:^{
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    }];
}



# pragma mark - XHOperationViewControllerDelegate
- (void)operationViewController:(XHOperationViewController *)operationVc didClickButton:(XHOperationViewControllerButton)button
{
 
    if (button == XHOperationViewControllerButtonPhone) {
        
        [takePhoto sharePicture:^(UIImage *image) {
            XHPhotoViewController *photoVc = [[XHPhotoViewController alloc]init];
            photoVc.mOrderFrame = self.selectedOrderFrame;
            photoVc.image = image;
            [mMyJobVc.navigationController pushViewController:photoVc animated:YES];
            [self dismissSemiModalView];
            NSLog(@"照片%@",image);
        }];
        
    }else if(button == XHOperationViewControllerButtonVoice){
 
        XHVoiceViewController *voiceVc = [[XHVoiceViewController alloc]init];
        voiceVc.mOrderFrame = self.selectedOrderFrame;
        [mMyJobVc.navigationController pushViewController:voiceVc animated:YES];
        [self dismissSemiModalView];
        
    }else if(button == XHOperationViewControllerButtonVideo){

        XHVideoViewController *videoVc = [[XHVideoViewController alloc]init];
        videoVc.mOrderFrame = self.selectedOrderFrame;
        [mMyJobVc.navigationController pushViewController:videoVc animated:YES];
        [self dismissSemiModalView];
        
    }else if(button == XHOperationViewControllerButtonAssist){
        
         XHAssistViewController *assistVc = [[XHAssistViewController alloc]init];
        assistVc.mOrderFrame = self.selectedOrderFrame;
        [mMyJobVc.navigationController pushViewController:assistVc animated:YES];
        [self dismissSemiModalView];
 
     }else if(button == XHOperationViewControllerButtonScan){
         
         [self go2QRCodeScan];
         
    }else if(button == XHOperationViewControllerButtonJieDan){
 
         XHJieDanViewController *jieDanVc = [[XHJieDanViewController alloc]init];
        jieDanVc.mOrderFrame = self.selectedOrderFrame;
        jieDanVc.mOrderFrame.order.opened = NO;
         [mMyJobVc.navigationController pushViewController:jieDanVc animated:YES];
        [self dismissSemiModalView];
        
      }else if(button == XHOperationViewControllerButtonGuaDan){
          
           XHGuaDanViewController *guaDanVc = [[XHGuaDanViewController alloc]init];
          guaDanVc.mOrderFrame = self.selectedOrderFrame;
          guaDanVc.mOrderFrame.order.opened = NO;
          [mMyJobVc.navigationController pushViewController:guaDanVc animated:YES];
          [self dismissSemiModalView];

      }else if(button == XHOperationViewControllerButtonYiDan){
        [SVProgressHUD showErrorWithStatus:@"暂无此功能"];
        [self dismissSemiModalView];
          
     }else{
         
        [SVProgressHUD showErrorWithStatus:@"暂无此功能"];
        [self dismissSemiModalView];
         
       }
   }
- (void)go2QRCodeScan
{
    //二维码
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
@end

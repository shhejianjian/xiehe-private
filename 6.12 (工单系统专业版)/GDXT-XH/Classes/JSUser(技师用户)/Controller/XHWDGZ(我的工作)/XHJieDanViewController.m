//
//  XHJieDanViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/4/21.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHJieDanViewController.h"
#import "NSString+FontAwesome.h"
#import "XHJieDanCenterCell.h"
#import "XHJieDanFooterView.h"
#import "XHOrderCell.h"
#import "XHInstructionCell.h"
#import "XHOrder.h"
#import "XHConst.h"
#import "XHSignatureView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XHHttpTool.h"
#import "XHOrderFrame.h"
@interface XHJieDanViewController ()<UITableViewDelegate,UITableViewDataSource,XHJieDanFooterViewDelegate,XHJieDanCenterCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *jieDanTableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *tempFilename;
@property (nonatomic, copy) NSString *evaluateStr;
@property (nonatomic, copy) NSString *url;
@end

@implementation XHJieDanViewController
static NSString *ID1 = @"XHOrderDetailCell";
static NSString *ID2 = @"XHAssessCell";
static NSString *ID3 = @"XHInstructionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [XHNotificationCenter addObserver:self selector:@selector(uploadSignatureImage:) name:XHSignatureFinishNotification object:nil];
}
- (void)uploadSignatureImage:(NSNotification *)info
{
    UIImage *image = info.userInfo[XHSignatureImage];
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,uploadUrl];
    // 2.发送请求
    [mgr POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"attachment" fileName:@"att.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        self.tempFilename = responseObject[@"tempFilename"];
        NSLog(@"上传成功%@",responseObject[@"tempFilename"]);
        [SVProgressHUD showSuccessWithStatus:@"上传成功" maskType:SVProgressHUDMaskTypeBlack];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"  maskType: SVProgressHUDMaskTypeBlack];
    }];
    

}
- (void)dealloc
{
    [XHNotificationCenter removeObserver:self];
}
- (void)setupTableView
{
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    

    [self.jieDanTableView registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID1];
    
    [self.jieDanTableView registerNib:[UINib nibWithNibName:@"XHJieDanCenterCell" bundle:nil] forCellReuseIdentifier:ID2];

    [self.jieDanTableView registerNib:[UINib nibWithNibName:@"XHInstructionCell" bundle:nil] forCellReuseIdentifier:ID3];
    XHJieDanFooterView *footerView = [XHJieDanFooterView footerView];
    footerView.delegate = self;
    self.jieDanTableView.tableFooterView = footerView;
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        XHOrderCell *firstCell = [self.jieDanTableView dequeueReusableCellWithIdentifier:ID1];
        firstCell.orderFrame = self.mOrderFrame;
        firstCell.lingLiaoBtn.hidden = YES;
        firstCell.jieDanBtn.hidden = YES;
        cell = firstCell;
        
    }else if (indexPath.section == 1){
        
        XHJieDanCenterCell *secondCell = [self.jieDanTableView dequeueReusableCellWithIdentifier:ID2];
        secondCell.delegate = self;
        cell = secondCell;
    
    }else{
        
        XHInstructionCell *secondCell = [self.jieDanTableView dequeueReusableCellWithIdentifier:ID3];
        cell = secondCell;
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
        [UIView animateWithDuration:1 animations:^{
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        }];
        

    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return (self.mOrderFrame.order.isOpened ? (self.mOrderFrame.cellHeight - 40): 200);
        
    }else if(indexPath.section == 1){
        
        return 150;
        
    }
    else{
        
        return 200;
        
    }
    
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"工单详情";
//    }else if (section == 1){
//        return nil;
//    }else{
//        return @"结单说明";
//    }
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc]init];
    if (section == 0) {
        lable.text = @"  工单详情";
    }else if(section == 2){
        lable.text = @"  结单说明";
    }
    return lable;
    
    
}
#pragma mark - XHJieDanFooterViewDelegate

- (void)jieDanFooterViewCheckButtonDidClick:(XHJieDanFooterView *)footerView
{
    NSLog(@"调待复核接口");
    if (!self.tempFilename) {
        [SVProgressHUD showInfoWithStatus:@"请先签字" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    if (!self.evaluateStr) {
        [SVProgressHUD showInfoWithStatus:@"请先评价" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    self.url = @"review";
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定待复核?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView show];
}
- (void)jieDanFooterViewJieDanButtonDidClick:(XHJieDanFooterView *)footerView
{
    if (!self.tempFilename) {
        [SVProgressHUD showInfoWithStatus:@"请先签字" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if (!self.evaluateStr) {
        [SVProgressHUD showInfoWithStatus:@"请先评价" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    self.url = @"complete";
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定结单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView show];
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self putToServicer:self.url];
    }
}
- (void)putToServicer:(NSString *)url;
{
    XHInstructionCell *cell = [self.jieDanTableView cellForRowAtIndexPath:self.indexPath];
    NSString *uploadUrl = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/%@",self.mOrderFrame.order.workOrderId,self.url];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sign"] = self.tempFilename;
    params[@"evaluate"] = self.evaluateStr;
    params[@"remark"] = cell.instructionmentTextView.text;
    [XHHttpTool put:uploadUrl params:params success:^(id json) {
        if ([self.url isEqualToString:@"complete"]) {
            [SVProgressHUD showSuccessWithStatus:@"结单成功" maskType:SVProgressHUDMaskTypeBlack];
        }else{
           [SVProgressHUD showSuccessWithStatus:@"待复核成功" maskType:SVProgressHUDMaskTypeBlack];
        }
        
       
        if ([self.notiStr isEqualToString:@"YGQ"]) {
            //通知已挂起控制器更新数据
             [XHNotificationCenter postNotificationName:XHYGQUpdateDataNotification object:nil];
        }else{
            //通知已接单控制器更新数据
              [XHNotificationCenter postNotificationName:XHYJDUpdateDateNotification object:nil];
        }

     [self.navigationController popViewControllerAnimated:YES];
        XHLog(@"结单成功%@-%@",json,params);
        
    } failure:^(NSError *error) {
        XHLog(@"结单失败%@-%@",error,params);
    }];


}
#pragma mark - XHJieDanCenterCellDelegate

- (void)jieDanCenterCell:(XHJieDanCenterCell *)cell didClickStar:(XHJieDanCenterCellStar)star
{
    if (star == XHJieDanCenterCellStarOne) {
        self.evaluateStr = @"1";
        NSLog(@"1颗星");
        
    }else if (star == XHJieDanCenterCellStarTwo){
        self.evaluateStr = @"2";

        NSLog(@"2颗星");

    
    }else if (star == XHJieDanCenterCellStarThree){
        self.evaluateStr = @"3";

        NSLog(@"3颗星");

        
    }else if (star == XHJieDanCenterCellStarFour){
        self.evaluateStr = @"4";

        NSLog(@"4颗星");

        
    }else{
        NSLog(@"5颗星");
        self.evaluateStr = @"5";

        
    }

}

- (void)jieDanCenterCellSignButtonDidClick:(XHJieDanCenterCell *)cell
{
    [XHSignatureView show];
 }

@end

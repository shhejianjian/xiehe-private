//
//  XHPhotoViewController.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/30.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHPhotoViewController.h"
#import "NSString+FontAwesome.h"
#import "UIView+Extension.h"
#import "XHFooterView.h"
#import "XHConst.h"
#import "XHGuaDanCenterCell.h"
#import "XHInstructionCell.h"
#import "SVProgressHUD.h"
#import "XHOption.h"
#import "XHOrder.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XHOptionUpload.h"
#import "XHHttpTool.h"
#import "MJExtension.h"
#import "XHOrderFrame.h"
@interface XHPhotoViewController ()<UITableViewDelegate, UITableViewDataSource,XHFooterViewDelegate,XHGuaDanCenterCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *photoTableView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) XHOption *selectedOption;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *tempFilename;

@end

@implementation XHPhotoViewController
static NSString *ID1 = @"XHGuaDanCenterCell";
static NSString *ID2 = @"XHInstructionCell";


   
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    [self setupTableView];
    [self uploadImage];
}
- (void)uploadImage
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,uploadUrl];
    // 2.发送请求
    [mgr POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        NSData *data = UIImageJPEGRepresentation(self.image, 1.0);
        [formData appendPartWithFileData:data name:@"attachment" fileName:@"att.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        self.tempFilename = responseObject[@"tempFilename"];
        NSLog(@"上传成功%@",responseObject[@"tempFilename"]);
        [SVProgressHUD showSuccessWithStatus:@"上传成功" maskType:SVProgressHUDMaskTypeBlack];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"  maskType: SVProgressHUDMaskTypeBlack];
    }];
}
- (void)setupTableView
{
    //1.tableview的头部
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = XHHeaderViewColor;
    view.width = [UIScreen mainScreen].bounds.size.width;
    view.height = 320;
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.x = 25;
    imageView.y = 10;
    imageView.width = view.width - 2 * imageView.x;
    imageView.height = view.height - 2 * imageView.y;
    imageView.image = self.image;
    [view addSubview:imageView];
    self.photoTableView.tableHeaderView = view;
    //2.tableView的底部
    XHFooterView *footerView = [XHFooterView footerView];
    footerView.btnTitle = @"确认";
    footerView.height = 150;
    footerView.delegate = self;
    self.photoTableView.tableFooterView = footerView;
    //注册cell
    [self.photoTableView registerNib:[UINib nibWithNibName:@"XHGuaDanCenterCell" bundle:nil] forCellReuseIdentifier:ID1];
    [self.photoTableView registerNib:[UINib nibWithNibName:@"XHInstructionCell" bundle:nil] forCellReuseIdentifier:ID2];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 数据源和代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        XHGuaDanCenterCell *firstCell = [self.photoTableView dequeueReusableCellWithIdentifier:ID1];
        firstCell.delegate = self;
        firstCell.optionUrl = photoOptionUrl;
        cell = firstCell;
    }else {
        XHInstructionCell *secondCell = [self.photoTableView dequeueReusableCellWithIdentifier:ID2];
        cell = secondCell;
     }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? 60 : 150;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc]init];
    lable.text = section == 0 ? @"  拍照选项" :@"  拍照说明";
    return lable;
}

#pragma mark - XHFooterViewDelegate
- (void)footerViewButtonDidClick:(XHFooterView *)footerView
{
    if (!self.selectedOption.name) {
        [SVProgressHUD showInfoWithStatus:@"请先选择一个拍照选项" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (!self.tempFilename) {
        [SVProgressHUD showInfoWithStatus:@"尚未拍照或上传拍照失败" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }

    XHInstructionCell *cell = [self.photoTableView cellForRowAtIndexPath:self.indexPath];
    NSString *uploadUrl = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/picture",self.mOrderFrame.order.workOrderId];
    XHOptionUpload *optionUpload = [[XHOptionUpload alloc]init];
    XHOption *option = [[XHOption alloc]init];
    option.name = self.selectedOption.name;
    option.objectId = self.selectedOption.objectId;
    optionUpload.option = option;
    optionUpload.remark = cell.instructionmentTextView.text;
    optionUpload.filename = self.tempFilename;
    [XHHttpTool put:uploadUrl params:optionUpload.mj_keyValues success:^(id json) {
        [SVProgressHUD showSuccessWithStatus:@"确认完成" maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
        XHLog(@"上传成功%@-%@",json,optionUpload.mj_keyValues);
        
    } failure:^(NSError *error) {
        XHLog(@"上传失败%@-%@",error,optionUpload.mj_keyValues);
    }];

}
#pragma mark - XHGuaDanFooterViewDelegate
- (void)GuaDanCenterCellOptionButtonDidClick:(XHGuaDanCenterCell *)cell Option:(XHOption *)option
{
    self.selectedOption = option;
    XHLog(@"点击了%@",option.name);
}
@end

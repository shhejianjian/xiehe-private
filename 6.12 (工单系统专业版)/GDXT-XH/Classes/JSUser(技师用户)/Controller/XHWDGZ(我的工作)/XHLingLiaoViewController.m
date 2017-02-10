//
//  XHLingLiaoViewController.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/13.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHLingLiaoViewController.h"
#import "XHOrderCell.h"
#import "XHInstructionCell.h"
#import "XHOrder.h"
#import "XHFooterView.h"
#import "IQKeyboardManager.h"
#import "NSString+FontAwesome.h"
#import "XHHttpTool.h"
#import "XHLingliao.h"
#import "MJExtension.h"
#import "XHSubLingliao.h"
#import "XHLingliaoCenterCell.h"
#import "UIView+Extension.h"
#import "XHUploadMaterial.h"
#import "XHMaterial.h"
#import "XHConst.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "XHOrderFrame.h"
#import "XHMaterial.h"
#import "XHUploadMaterial.h"
@interface XHLingLiaoViewController ()<UITableViewDelegate, UITableViewDataSource,XHFooterViewDelegate,XHLingliaoCenterCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *lingLiaoTableView;
@property (strong ,nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong ,nonatomic) NSMutableArray *lingliaos;
@property (strong ,nonatomic) UIAlertController *alert;
@end

@implementation XHLingLiaoViewController
static NSString *ID1 = @"XHLingliaoDetailCell";
static NSString *ID2 = @"XHInstructionCell";
static NSString *ID3 = @"XHLingliaoCenterCell";
- (NSMutableArray *)lingliaos
{
    if (!_lingliaos) {
        _lingliaos = [[NSMutableArray alloc]init];
    }
    return _lingliaos;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self loadMaterilas];
   }
- (void)loadMaterilas
{
    NSString *url = [NSString stringWithFormat:@"%@=%@",LingliaorUrl,self.mOrderFrame.order.workOrderId];
    [XHHttpTool get:url params:nil success:^(id json) {
        self.lingliaos = [XHLingliao mj_objectArrayWithKeyValuesArray:json];
        if (self.lingliaos.count) {
            [self.lingLiaoTableView registerNib:[UINib nibWithNibName:@"XHLingliaoCenterCell" bundle:nil] forCellReuseIdentifier:ID3];
        }
    [self.lingLiaoTableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败%@",error);
    }];
 
}
- (void)setupTableView
{
    self.backButton.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backButton setTitle:@"\uf2ea" forState:UIControlStateNormal];    [self.lingLiaoTableView registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID1];
    [self.lingLiaoTableView registerNib:[UINib nibWithNibName:@"XHInstructionCell" bundle:nil] forCellReuseIdentifier:ID2];
   
    XHFooterView *footerView = [XHFooterView footerView];
    footerView.delegate = self;
    footerView.btnTitle = @"领料";
    self.lingLiaoTableView.tableFooterView = footerView;
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}
#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.lingliaos.count ? (self.lingliaos.count + 2) : 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.lingliaos.count) {
        if (section == 0 || section == self.lingliaos.count + 1) {
            return 1;
        }else{
            XHLingliao *lingliao = self.lingliaos[section - 1];
            return lingliao.items.count;
        }
        
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (self.lingliaos.count) {
        if (indexPath.section == 0) {
            XHOrderCell *firstCell = [self.lingLiaoTableView dequeueReusableCellWithIdentifier:ID1];
            firstCell.orderFrame = self.mOrderFrame;
            firstCell.lingLiaoBtn.hidden = YES;
            firstCell.jieDanBtn.hidden = YES;
            cell = firstCell;
        }else if (indexPath.section == self.lingliaos.count + 1){
            XHInstructionCell *secondCell = [self.lingLiaoTableView dequeueReusableCellWithIdentifier:ID2];
            cell = secondCell;
            self.indexPath = indexPath;
        }else{
           XHLingliaoCenterCell *centerCell  = [tableView dequeueReusableCellWithIdentifier:ID3];
            XHLingliao *lingliao = self.lingliaos[indexPath.section - 1];
            centerCell.delegate = self;
            XHSubLingliao *subLingliao = lingliao.items[indexPath.row];
            [centerCell.selectedButton setTitle:subLingliao.name forState:UIControlStateNormal];
            cell = centerCell;
        }
        
    }else{
        if (indexPath.section == 0) {
            XHOrderCell *firstCell = [self.lingLiaoTableView dequeueReusableCellWithIdentifier:ID1];
            firstCell.orderFrame = self.mOrderFrame;
            firstCell.lingLiaoBtn.hidden = YES;
            firstCell.jieDanBtn.hidden = YES;
            cell = firstCell;
        }else{
            XHInstructionCell *secondCell = [self.lingLiaoTableView dequeueReusableCellWithIdentifier:ID2];
            cell = secondCell;
            self.indexPath = indexPath;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.mOrderFrame.order.opened = !self.mOrderFrame.order.isOpened;
        [UIView animateWithDuration:0.7 animations:^{
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        }];
      }
   }
- (void)showAlertAtIndexpath:(NSIndexPath *)indexPath
{
    XHLingliao *lingliao = self.lingliaos[indexPath.section - 1];
    XHSubLingliao *sub = lingliao.items[indexPath.row];
    NSString *content = [NSString stringWithFormat:@"请输入%@数量",sub.name];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:content preferredStyle:UIAlertControllerStyleAlert];
    // 添加按钮
    
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if (sub.isSelected) {
            sub.selected = !sub.isSelected;
            NSRange range =[sub.name rangeOfString:@"(" options:NSBackwardsSearch];
            sub.name = [sub.name substringToIndex:range.location];
            sub.count = nil;
        }
        sub.count = weakAlert.textFields.firstObject.text;
        sub.name = [NSString stringWithFormat:@"%@(%@%@)",sub.name,weakAlert.textFields.firstObject.text,sub.unit];
        sub.selected = YES;
       XHLingliaoCenterCell *cell =  [self.lingLiaoTableView cellForRowAtIndexPath:indexPath];
        cell.selectedButton.selected = YES;
        [self.lingLiaoTableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

     // 添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = @"1";
        textField.tintColor = [UIColor orangeColor];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textField addTarget:self action:@selector(countDidChange:) forControlEvents:UIControlEventEditingChanged];

    }];
    self.alert = alert;
    [self presentViewController:alert animated:YES completion:nil];
}
//监听输入数量发生变化
- (void)countDidChange:(UITextField *)count
{
    UIAlertAction *action = self.alert.actions.firstObject;
    if (count.text.length > 3 || count.text.length == 0 || [[count.text substringToIndex:1] isEqualToString:@"0"]) {
        action.enabled = NO;
    }else{
        action.enabled = YES;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lingliaos.count) {
        if (indexPath.section == 0) {
            return (self.mOrderFrame.order.isOpened ? (self.mOrderFrame.cellHeight - 40) : 200);
        }else if (indexPath.section == self.lingliaos.count + 1){
            return 200;
        }else{
            return 44;
        }
    }else{
        if (indexPath.section == 0) {
            return (self.mOrderFrame.order.isOpened ? (self.mOrderFrame.cellHeight - 40) : 200);
        }else{
            return 200;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lable = [[UILabel alloc]init];
    if (self.lingliaos.count) {
        if (section == 0) {
            lable.text = @"  工单详情";
        }else if (section == self.lingliaos.count + 1){
            lable.text = @"  领料说明";
        }else{
            XHLingliao *lingliao = self.lingliaos[section - 1];
            lable.text = lingliao.name;
            lable.text = [NSString stringWithFormat:@"  %@",lingliao.name];
        }
    }else{
        if (section == 0) {
            lable.text = @"  工单详情";
        }else{
            lable.text = @"  领料说明";
        }
    }
     return lable;
 }

#pragma mark - XHLingliaoCenterCellDelegate

- (void)lingliaoCenterCellButtonDidClick:(XHLingliaoCenterCell *)lingliaoCell;
{
   NSIndexPath *indexPath = [self.lingLiaoTableView indexPathForCell:lingliaoCell];
    XHLingliao *lingliao = self.lingliaos[indexPath.section - 1];
    XHSubLingliao *sub = lingliao.items[indexPath.row];
    
   
    if (sub.isSelected) {
        sub.selected = !sub.isSelected;
        NSRange range =[sub.name rangeOfString:@"(" options:NSBackwardsSearch];
        sub.count = nil;
        sub.name = [sub.name substringToIndex:range.location];
        [self.lingLiaoTableView reloadData];
    }else{
            //显示alert
        [self showAlertAtIndexpath:indexPath];
    }
}

#pragma mark - XHFooterViewDelegate
- (void)footerViewButtonDidClick:(XHFooterView *)footerView
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定领料?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView show];

   
//    NSLog(@"调领料接口参数%@",params);
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableArray *uploadMaterials = [[NSMutableArray alloc]init];
        if (self.lingliaos.count) {
            for (int i = 0; i < self.lingliaos.count; i ++) {
                XHLingliao *lingliao = self.lingliaos[i];
                for (int j = 0; j < lingliao.items.count; j++) {
                    XHSubLingliao *sub = lingliao.items[j];
                    if (sub.isSelected) {
                        XHUploadMaterial *uploadMaterial = [[XHUploadMaterial alloc]init];
                        XHMaterial *material = [[XHMaterial alloc]init];
                        NSRange range =[sub.name rangeOfString:@"(" options:NSBackwardsSearch];
                        material.name = [sub.name substringToIndex:range.location];
                        material.objectId = sub.objectId;
                        uploadMaterial.material = material;
                        uploadMaterial.amount = sub.count;
                        [uploadMaterials addObject:uploadMaterial.mj_keyValues];
                    }
                }
            }
        }
        XHInstructionCell *cell = [self.lingLiaoTableView cellForRowAtIndexPath:self.indexPath];
        XHUploadMaterial *uploadMaterial = [[XHUploadMaterial alloc]init];
        uploadMaterial.materialInfo = cell.instructionmentTextView.text;
        [uploadMaterials addObject:uploadMaterial.mj_keyValues];
        //领料上传的url
        NSString *uploadUrl = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/supply",self.mOrderFrame.order.workOrderId];
        XHLog(@"领料%@",uploadMaterials);
        [XHHttpTool put:uploadUrl params:uploadMaterials success:^(id json) {
             [SVProgressHUD showSuccessWithStatus:@"领料成功"];
            [self dismissViewControllerAnimated:NO completion:nil];
            if ([self.notiStr isEqualToString:@"YGQ"]) {
                //通知已挂起控制器更新数据
                [XHNotificationCenter postNotificationName:XHYGQUpdateDataNotification object:nil];
            }else{
                //通知已接单控制器更新数据
                [XHNotificationCenter postNotificationName:XHYJDUpdateDateNotification object:nil];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"领料失败"];
         }];
    }
}
@end

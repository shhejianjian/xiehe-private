//
//  XHGDCXViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHGDCXViewController.h"
#import "CDRTranslucentSideBar.h"
#import "NSString+FontAwesome.h"
#import "XHLeftCell.h"
#import "XHConst.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeScanViewController.h"
#import "QRCodeGenerator.h"
#import "XHMyJobViewController.h"
#import "XHSearchResultViewController.h"
#import "XHLoginViewController.h"
#import "XHSearchListCell.h"
#import "XHOrderSummaryViewController.h"
#import "XHGDLXTreeViewController.h"
#import "XHKSViewController.h"
#import "XHEquipmentTreeViewController.h"
#import "XHGDZTTreeViewController.h"
#import "XHEmergencyTree.h"
#import "YTDatePick.h"
#import "XHZGJobViewController.h"
#import "XHYJMainViewController.h"
#import "AFNetWorking.h"
#import "SVProgressHUD.h"
static NSString *ID=@"leftViewCell";
static NSString *myTableViewID=@"mainCell";
@interface XHGDCXViewController ()<CDRTranslucentSideBarDelegate,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,XHSearchListCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *leftViewBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightViewBtn;
@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;
@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;
@property (nonatomic, copy) UIView *bgView;
@property (nonatomic, copy) NSString *startDateStr;
@property (nonatomic, copy) NSString *endDateStr;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end


extern NSString *departmentStr;
extern NSString *gdlxStr;
extern NSString *equipmentStr;
extern NSString *statusStr;
extern NSString *emergencyStr;
extern NSString *departmentID;
extern NSString *gdlxID;
extern NSString *equipmentID;
extern NSString *statusID;
extern NSString *emergencyID;
extern NSString *userType;
extern XHMyJobViewController *mMyJobVc;

@implementation XHGDCXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sideBar = [[CDRTranslucentSideBar alloc] init];
    self.sideBar.sideBarWidth = [UIScreen mainScreen].bounds.size.width * 0.8;
    self.sideBar.delegate = self;
    self.sideBar.tag = 1;
    
    UITableView *leftTableView = [[UITableView alloc] init];
    leftTableView.dataSource = self;
    leftTableView.delegate = self;
    leftTableView.bounces = NO;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [leftTableView registerNib:[UINib nibWithNibName:@"XHLeftCell" bundle:nil] forCellReuseIdentifier:ID];
    [self.sideBar setContentViewInSideBar:leftTableView];
    
    self.rightViewBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    [self.rightViewBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconSearch] forState:UIControlStateNormal];
    [self.rightViewBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconSearch] forState:UIControlStateSelected];
    
    
    
    self.leftViewBtn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    [self.leftViewBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconReorder] forState:UIControlStateNormal];
    [self.leftViewBtn setTitle:[NSString fontAwesomeIconStringForEnum:FAIconReorder] forState:UIControlStateSelected];
    [self.myTableView registerNib:[UINib nibWithNibName:@"XHSearchListCell" bundle:nil] forCellReuseIdentifier:myTableViewID];
    
    self.myTableView.bounces = NO;
    [self createCancleNotifation];
    [self createNotifation];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.myTableView reloadData];
}
- (IBAction)rightViewClick:(id)sender {
    XHSearchResultViewController *resultVC = [[XHSearchResultViewController alloc]init];
    resultVC.departmentId = departmentID;
    resultVC.gdlxId = gdlxID;
    resultVC.statusId = statusID;
    resultVC.emergencyId = emergencyID;
    resultVC.equipmentId = equipmentID;
    resultVC.startDate = _startDateStr;
    resultVC.endDate = _endDateStr;
    [self.navigationController pushViewController:resultVC animated:YES];
}
- (IBAction)clickLeftView:(id)sender {
    [self.sideBar show];
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
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.6;
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
#pragma mark - XHSearchListCellDelegate
- (void)XHSearchListCellClickButton:(XHSearchListCell *)cell AtIndex:(NSInteger)index {
    if (index == 0) {
        XHGDLXTreeViewController *gdlxTreeVC = [[XHGDLXTreeViewController alloc]init];
        [self.navigationController pushViewController:gdlxTreeVC animated:YES];
    } else if (index == 1) {
        XHKSViewController *ksTreeVC = [[XHKSViewController alloc]init];
        [self.navigationController pushViewController:ksTreeVC animated:YES];
    } else if (index == 2) {
        XHEquipmentTreeViewController *equTreeVC = [[XHEquipmentTreeViewController alloc]init];
        [self.navigationController pushViewController:equTreeVC animated:YES];
    } else if (index == 3) {
        XHGDZTTreeViewController *gdztTreeVC = [[XHGDZTTreeViewController alloc]init];
        [self.navigationController pushViewController:gdztTreeVC animated:YES];
    } else if (index == 4) {
        XHEmergencyTree *emergencyTreeVC = [[XHEmergencyTree alloc]init];
        [self.navigationController pushViewController:emergencyTreeVC animated:YES];
    } else if (index == 5) {
        [self.view endEditing:YES];
        [self createBackgroundView];
        [YTDatePick showPickWithMakeSure:^(id year, id month, id day) {
            cell.chooseTF.text = [NSString stringWithFormat:@"%@ - %@ - %@",year,month,day];
            NSDate *startDate = [self dateFromString:[NSString stringWithFormat:@"%@-%@-%@",year,month,day]];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[startDate timeIntervalSince1970]];
            _startDateStr = timeSp;
            [self.myTableView reloadData];
        }];
    } else if (index == 6) {
        [self.view endEditing:YES];
        [self createBackgroundView];
        [YTDatePick showPickWithMakeSure:^(id year, id month, id day) {
            cell.chooseTF.text = [NSString stringWithFormat:@"%@ - %@ - %@",year,month,day];
            NSDate *endDate = [self dateFromString:[NSString stringWithFormat:@"%@-%@-%@",year,month,day]];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[endDate timeIntervalSince1970]];
            _endDateStr = timeSp;
            [self.myTableView reloadData];
        }];
    }

}
- (void)XHSearchListCellDeleteButton:(XHSearchListCell *)cell AtIndex:(NSInteger)index {
    if (index == 0) {
        cell.chooseTF.text = @"";
        if (cell.chooseTF.text.length == 0) {
            gdlxStr = nil;
            gdlxID = nil;
            cell.deleteBtn.hidden = YES;
        }
        cell.tipLabel.hidden = YES;
    } else if (index == 1) {
        cell.chooseTF.text = @"";
        if (cell.chooseTF.text.length == 0) {
            departmentStr = nil;
            departmentID = nil;
            cell.deleteBtn.hidden = YES;
        }
        cell.tipLabel.hidden = YES;
    } else if (index == 2) {
        cell.chooseTF.text = @"";
        if (cell.chooseTF.text.length == 0) {
            equipmentStr = nil;
            equipmentID = nil;
            cell.deleteBtn.hidden = YES;
        }
        cell.tipLabel.hidden = YES;
    } else if (index == 3) {
        cell.chooseTF.text = @"";
        if (cell.chooseTF.text.length == 0) {
            statusStr = nil;
            statusID = nil;
            cell.deleteBtn.hidden = YES;
        }
        cell.tipLabel.hidden = YES;
    } else if (index == 4) {
        cell.chooseTF.text = @"";
        if (cell.chooseTF.text.length == 0) {
            emergencyStr = nil;
            emergencyID = nil;
            cell.deleteBtn.hidden = YES;
        }
        cell.tipLabel.hidden = YES;
    } else if (index == 5) {
        cell.chooseTF.text = @"";
        cell.tipLabel.hidden = YES;
        if (cell.chooseTF.text.length == 0) {
            self.startDateStr = nil;
            cell.deleteBtn.hidden = YES;
        }
    } else if (index == 6) {
        cell.chooseTF.text = @"";
        cell.tipLabel.hidden = YES;
        if (cell.chooseTF.text.length == 0) {
            self.endDateStr = nil;
            cell.deleteBtn.hidden = YES;
        }
    }
}
#pragma mark - textFileDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.myTableView) {
        return 7;
    }
    if ([userType isEqualToString:@"Manager"]) {
        return 6;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.myTableView) {
        return 0;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.myTableView) {
        return 80;
    }
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.myTableView) {
        XHSearchListCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableViewID];
        if (!cell) {
            cell=[[XHSearchListCell alloc]init];
        }
        cell.chooseTF.delegate = self;
        cell.deleteBtn.tag = indexPath.row;

        cell.chooseBtn.tag = indexPath.row;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.chooseTF.placeholder = @"选择工单类型";
            if (gdlxStr) {
                cell.chooseTF.text = gdlxStr;
            }
            cell.tipLabel.text = @"选择工单类型";
        } else if (indexPath.row == 1) {
            cell.chooseTF.placeholder = @"选择科室";
            if (departmentStr) {
                cell.chooseTF.text = departmentStr;
            }
            cell.tipLabel.text = @"选择科室";
            
        } else if (indexPath.row == 2) {
            cell.chooseTF.placeholder = @"选择维修设备";
            if (equipmentStr) {
                cell.chooseTF.text = equipmentStr;
            }
            cell.tipLabel.text = @"选择维修设备";
            
        } else if (indexPath.row == 3) {
            cell.chooseTF.placeholder = @"选择工单状态";
            if (statusStr) {
                cell.chooseTF.text = statusStr;
            }
            cell.tipLabel.text = @"选择工单状态";
            
        } else if (indexPath.row == 4) {
            cell.chooseTF.placeholder = @"选择工单级别";
            if (emergencyStr) {
                cell.chooseTF.text = emergencyStr;
            }
            cell.tipLabel.text = @"选择工单级别";
            
        } else if (indexPath.row == 5) {
            cell.chooseTF.placeholder = @"选择起始报修时间";
            cell.tipLabel.text = @"选择起始报修时间";
            
        } else if (indexPath.row == 6) {
            cell.chooseTF.placeholder = @"选择结束报修时间";
            cell.tipLabel.text = @"选择结束报修时间";
            
        }
        if (cell.chooseTF.text.length != 0) {
            cell.tipLabel.hidden = NO;
            cell.deleteBtn.hidden = NO;
        } else {
            cell.tipLabel.hidden = YES;
            cell.deleteBtn.hidden = YES;
        }
        return cell;
    } else {
        XHLeftCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell=[[XHLeftCell alloc]init];
        }
        cell.leftViewLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:25];
        
        if ([userType isEqualToString:@"Manager"]) {
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
        } else {
            if (indexPath.row == 0) {
                cell.leftViewLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:30];
                cell.leftViewLabel.text = @"\uf10c";
                cell.titleLabel.text = @"我的工作";
            } else if (indexPath.row == 1) {
                cell.leftViewLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:30];
                cell.leftViewLabel.text = @"\uf1c0";
                cell.titleLabel.text = @"工单查询";
            } else if (indexPath.row == 2) {
                cell.leftViewLabel.text = @"\uf130";
                cell.titleLabel.text = @"工单汇总";
            } else if (indexPath.row == 3) {
                cell.leftViewLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:35];
                cell.leftViewLabel.text = @"\uf16d";
                cell.titleLabel.text = @"设备扫码";
            } else if (indexPath.row == 4) {
                cell.leftViewLabel.text = @"\uf1cc";
                cell.titleLabel.text = @"用户登出";
            }
        }
        
        
        
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.myTableView) {
       
    } else {
        [self.sideBar dismiss];
        
        if ([userType isEqualToString:@"Manager"]) {
            
            if (indexPath.row == 0) {
                XHZGJobViewController *mainVC = [[XHZGJobViewController alloc]init];
                [self.navigationController pushViewController:mainVC animated:YES];
            }
            if (indexPath.row == 1) {
                
            }
            if (indexPath.row == 2) {
                
                XHYJMainViewController *yjMainVc = [[XHYJMainViewController alloc] init];
                
                [self.navigationController pushViewController:yjMainVc animated:YES];
                
            }
            if (indexPath.row == 3) {
                
                XHOrderSummaryViewController *sumVc = [[XHOrderSummaryViewController alloc] init];
                
                [self.navigationController pushViewController:sumVc animated:YES];
                
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
                [self jumpToVC];
            }

            
        } else {
            if (indexPath.row == 0) {
                XHMyJobViewController *mainVC = [[XHMyJobViewController alloc]init];
                [self.navigationController pushViewController:mainVC animated:YES];
            }
            if (indexPath.row == 1) {
                
            }
            if (indexPath.row == 2) {
                
                XHOrderSummaryViewController *sumVc = [[XHOrderSummaryViewController alloc] init];
                
                [self.navigationController pushViewController:sumVc animated:YES];
                
            }
            if (indexPath.row == 3) {
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
            if (indexPath.row == 4) {
                [self logOut];
            }

        }
        
        
        
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        mMyJobVc = nil;
        [self jumpToVC];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"退出失败"];
    }];
    
}
- (void)jumpToVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
//    CATransition* transition = [CATransition animation];
//    transition.type = kCATransitionPush;//可更改为其他方式
//    transition.subtype=kCATransitionFromLeft;
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    
//    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"login"] animated:YES];
}

#pragma mark -- 时间选择器
-(void)createCancleNotifation{
    if([self respondsToSelector:@selector(setCancleValueChanges)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCancleValueChanges) name:@"setCancleValueChanges" object:nil];
    }
}
-(void)createNotifation{
    if([self respondsToSelector:@selector(setCancleValueChanges)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCancleValueChanges) name:@"setInfor" object:nil];
    }
}
-(void)setCancleValueChanges {
    [_bgView removeFromSuperview];
}


@end

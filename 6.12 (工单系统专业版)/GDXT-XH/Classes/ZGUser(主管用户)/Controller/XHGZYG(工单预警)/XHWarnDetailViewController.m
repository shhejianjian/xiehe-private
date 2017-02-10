//
//  XHWarnDetailViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/19.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHWarnDetailViewController.h"
#import "NSString+FontAwesome.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "XHOrder.h"
#import "XHOrderFrame.h"
#import "XHOrderCell.h"
static NSString *ID=@"xhWarnDetailCell";
@interface XHWarnDetailViewController () <XHOrderCellDelegate>
@property (strong, nonatomic) IBOutlet UIButton *leftViewBtn;
@property (nonatomic, strong) NSMutableArray *DjdOrderFrames;
@property (strong, nonatomic) IBOutlet UITableView *warnDetailTableView;

@end

@implementation XHWarnDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.warnDetailTableView registerNib:[UINib nibWithNibName:@"XHOrderCell" bundle:nil] forCellReuseIdentifier:ID];
    self.warnDetailTableView.bounces = NO;
    self.leftViewBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.leftViewBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    [self loadWordOrderDetail];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadWordOrderDetail {
    NSString *url = [NSString stringWithFormat:@"api/v1/hems/workOrder/%@/info",self.workOrderId];
    [XHHttpTool get:url params:nil success:^(id json) {
        NSLog(@"--%@",json);
        XHOrder *order = [XHOrder mj_objectWithKeyValues:json];
        order.opened = YES;
        XHOrderFrame *orderFrame = [[XHOrderFrame alloc]init];
        orderFrame.order = order;
        [self.DjdOrderFrames addObject:orderFrame];
        [self.warnDetailTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"==%@",error);
    }];
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.DjdOrderFrames.count;
}
- (XHOrderCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[XHOrderCell alloc]init];
    }
    cell.lingLiaoBtn.hidden = YES;
    cell.jieDanBtn.hidden = YES;
    cell.detailView.layer.shadowOffset =  CGSizeMake(0, 0);
    cell.detailView.layer.shadowOpacity = 0;
    cell.delegate = self;
    cell.bxryBtn.tag = indexPath.row;
    cell.receiverButton.tag = indexPath.row;
    cell.orderFrame = self.DjdOrderFrames[indexPath.row];
    cell.detailView.backgroundColor = self.view.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
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


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSMutableArray *)DjdOrderFrames {
	if(_DjdOrderFrames == nil) {
		_DjdOrderFrames = [[NSMutableArray alloc] init];
	}
	return _DjdOrderFrames;
}

@end

//
//  XHGDZTTreeViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/13.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHGDZTTreeViewController.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "NSString+FontAwesome.h"
#import "BDDynamicTreeNode.h"
#import "XHDepartment.h"
#import "MJExtension.h"
@interface XHGDZTTreeViewController ()
{
    BDDynamicTree *_dynamicTree1;
    
}
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) NSMutableArray *departmentArr;

@end

NSString *statusStr;
NSString *statusID;
@implementation XHGDZTTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    [self loadGDZT];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadGDZT {
    NSString *urlStr = @"api/v1/system/code/tree?tag=WorkOrderStatus";
    [XHHttpTool get:urlStr params:nil success:^(id json) {
        NSArray *arr = [XHDepartment mj_objectArrayWithKeyValuesArray:json];
        BDDynamicTreeNode *root = [[BDDynamicTreeNode alloc] init];
        root.originX = 20.f;
        root.isDepartment = YES;
        root.fatherNodeId = nil;
        root.nodeId = @"1000";
        root.name = @"请选择工单状态";
        root.data = @{@"name":@"请选择工单状态"};
        [self.departmentArr addObject:root];
        
        for (XHDepartment *status in arr) {
            BDDynamicTreeNode *subStatus = [[BDDynamicTreeNode alloc] init];
            subStatus.isDepartment = NO;
            subStatus.fatherNodeId = @"1000";
            subStatus.nodeId = status.objectId;
            subStatus.name = status.name;
            subStatus.data = @{@"name":status.name};
            [self.departmentArr addObject:subStatus];
        }
        [self setupUI];
    } failure:^(NSError *error) {
        
    }];
}
- (void)setupUI {
    _dynamicTree1 = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) nodes:self.departmentArr];
    _dynamicTree1.delegate = self;
    [self.view addSubview:_dynamicTree1];
    
}

- (void)dynamicTree:(BDDynamicTree *)dynamicTree didSelectedRowWithNode:(BDDynamicTreeNode *)node
{
    if (!node.isDepartment) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"确认选择此项吗？" message:node.name preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            statusStr = node.name;
            statusID = node.nodeId;
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
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

- (NSMutableArray *)departmentArr {
	if(_departmentArr == nil) {
		_departmentArr = [[NSMutableArray alloc] init];
	}
	return _departmentArr;
}

@end

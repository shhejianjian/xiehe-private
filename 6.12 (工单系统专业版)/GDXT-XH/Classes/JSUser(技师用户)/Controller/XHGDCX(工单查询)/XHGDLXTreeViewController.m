//
//  XHGDLXTreeViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/5.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHGDLXTreeViewController.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "NSString+FontAwesome.h"
#import "BDDynamicTreeNode.h"
#import "XHDepartment.h"
#import "MJExtension.h"
@interface XHGDLXTreeViewController ()
{
    BDDynamicTree *_dynamicTree1;
    
}
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) NSMutableArray *departmentArr;
@end


NSString *gdlxStr;
NSString *gdlxID;
@implementation XHGDLXTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    [self loadGDLX];
    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)loadGDLX {
    NSString *urlStr = @"api/v1/system/code/tree?fetchChild=true&tag=WorkOrderType";
    [XHHttpTool get:urlStr params:nil success:^(id json) {
        NSArray *arr = [XHDepartment mj_objectArrayWithKeyValuesArray:json];
        BDDynamicTreeNode *root = [[BDDynamicTreeNode alloc] init];
        root.originX = 20.f;
        root.isDepartment = YES;
        root.fatherNodeId = nil;
        root.nodeId = @"1000";
        root.name = @"请选择工单类型";
        root.data = @{@"name":@"请选择工单类型"};
        [self.departmentArr addObject:root];
        
        for (XHDepartment *type in arr) {
            BDDynamicTreeNode *root = [[BDDynamicTreeNode alloc] init];
            if ([type.leaf isEqualToString:@"1"]) {
                root.isDepartment = NO;
            } else {
                root.isDepartment = YES;
            }
            root.fatherNodeId = @"1000";
            root.nodeId = type.objectId;
            root.name = type.name;
            root.data = @{@"name":type.name};
            [self.departmentArr addObject:root];
            
            for (XHDepartment *subType in type.items) {
                BDDynamicTreeNode *typeItem = [[BDDynamicTreeNode alloc] init];
                typeItem.isDepartment = NO;
                typeItem.fatherNodeId = type.objectId;
                typeItem.nodeId = subType.objectId;
                typeItem.name = subType.name;
                typeItem.data = @{@"name":subType.name};
                [self.departmentArr addObject:typeItem];
            }
        }
        
        [self setupUI];
    } failure:^(NSError *error) {
        NSLog(@"%@--",error);
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
            
            gdlxStr = node.name;
            gdlxID = node.nodeId;
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

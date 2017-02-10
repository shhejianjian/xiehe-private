//
//  XHKSViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/11.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHKSViewController.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "NSString+FontAwesome.h"
#import "BDDynamicTreeNode.h"
#import "XHDepartment.h"
#import "MJExtension.h"
@interface XHKSViewController ()
{
    BDDynamicTree *_dynamicTree1;
    
}
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) NSMutableArray *departmentArr;
@end

NSString *departmentStr;
NSString *departmentID;
@implementation XHKSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    [self loadDepartment];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadDepartment {
    NSString *urlStr = @"/api/v1/hems/department/tree?id=1&fetchChild=true";
    [XHHttpTool get:urlStr params:nil success:^(id json) {
        NSArray *arr = [XHDepartment mj_objectArrayWithKeyValuesArray:json];
        
        BDDynamicTreeNode *root1 = [[BDDynamicTreeNode alloc] init];
        root1.originX = 20.f;
        root1.isDepartment = YES;
        root1.fatherNodeId = nil;
        root1.nodeId = @"1000";
        root1.name = @"请选择科室";
        root1.data = @{@"name":@"请选择科室"};
        [self.departmentArr addObject:root1];
        
        
        for (XHDepartment *dep in arr) {
            
            BDDynamicTreeNode *root = [[BDDynamicTreeNode alloc] init];
            root.originX = 20.f;
            root.isDepartment = YES;
            root.fatherNodeId = @"1000";
            root.nodeId = dep.objectId;
            root.name = dep.name;
            root.data = @{@"name":dep.name};
            [self.departmentArr addObject:root];
            for (XHDepartment *subDep in dep.items) {
                BDDynamicTreeNode *subDepartment = [[BDDynamicTreeNode alloc]init];
                if ([subDep.leaf isEqualToString:@"1"]) {
                    subDepartment.isDepartment = NO;
                } else {
                    subDepartment.isDepartment = YES;
                }
                subDepartment.fatherNodeId = dep.objectId;
                subDepartment.nodeId = subDep.objectId;
                subDepartment.name = subDep.name;
                subDepartment.data = @{@"name":subDep.name};
                [self.departmentArr addObject:subDepartment];
                for (XHDepartment *smallDep in subDep.items) {
                    
                    BDDynamicTreeNode *smallDepartment = [[BDDynamicTreeNode alloc]init];
                    smallDepartment.isDepartment = YES;
                    if ([smallDep.leaf isEqualToString:@"1"]) {
                        smallDepartment.isDepartment = NO;
                    } else {
                        smallDepartment.isDepartment = YES;
                    }
                    smallDepartment.fatherNodeId = subDep.objectId;
                    smallDepartment.nodeId =smallDep.objectId;
                    smallDepartment.name = smallDep.name;
                    smallDepartment.data = @{@"name":smallDep.name};
                    [self.departmentArr addObject:smallDepartment];
                    
                    
                }
            }
        }
        
        _dynamicTree1 = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) nodes:self.departmentArr];
        _dynamicTree1.delegate = self;
        [self.view addSubview:_dynamicTree1];
        
    } failure:^(NSError *error) {
        NSLog(@"%@--",error);
    }];
}

- (void)dynamicTree:(BDDynamicTree *)dynamicTree didSelectedRowWithNode:(BDDynamicTreeNode *)node
{
    if (!node.isDepartment) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"确认选择此项吗？" message:node.name preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            departmentStr = node.name;
            departmentID = node.nodeId;
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

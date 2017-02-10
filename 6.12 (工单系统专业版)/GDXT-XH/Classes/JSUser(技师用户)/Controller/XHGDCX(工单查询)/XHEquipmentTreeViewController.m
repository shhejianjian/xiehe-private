//
//  XHEquipmentTreeViewController.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/11.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHEquipmentTreeViewController.h"
#import "XHHttpTool.h"
#import "XHConst.h"
#import "NSString+FontAwesome.h"
#import "BDDynamicTreeNode.h"
#import "XHDepartment.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"


@interface XHEquipmentTreeViewController ()
{
    BDDynamicTree *_dynamicTree1;
    
}
@property (nonatomic, strong) NSMutableArray *equipmentArr;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) NSMutableArray *firstEquArr;

@end

NSString *equipmentStr;
NSString *equipmentID;
@implementation XHEquipmentTreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:20];
    [self.backBtn setTitle:@"\uf2ea" forState:UIControlStateNormal];
    [self loadEquipment];
   }
- (void)loadEquipment {
    NSString *rootUrlStr = @"api/v1/hems/equipment/tree?id=root";
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [XHHttpTool get:rootUrlStr params:nil success:^(id json) {
        NSArray *arr = [XHDepartment mj_objectArrayWithKeyValuesArray:json];
        BDDynamicTreeNode *root = [[BDDynamicTreeNode alloc] init];
        root.originX = 20.f;
        root.isDepartment = YES;
        root.fatherNodeId = nil;
        root.nodeId = @"1000";
        root.name = @"请选择维修设备";
        root.data = @{@"name":@"请选择维修设备"};
        [self.equipmentArr addObject:root];

        for (XHDepartment *mainEquipment in arr) {
            BDDynamicTreeNode *euqipment = [[BDDynamicTreeNode alloc] init];
            euqipment.isDepartment = YES;
            euqipment.fatherNodeId = @"1000";
            euqipment.nodeId = mainEquipment.objectId;
            euqipment.name = mainEquipment.name;
            euqipment.data = @{@"name":mainEquipment.name};
            [self.equipmentArr addObject:euqipment];
            NSString *subUrlStr = [NSString stringWithFormat:@"api/v1/hems/equipment/tree?id=%@",mainEquipment.ID];
            [XHHttpTool get:subUrlStr params:nil success:^(id json) {
        NSArray *subArr = [XHDepartment mj_objectArrayWithKeyValuesArray:json];
       for (XHDepartment *subEquipment in subArr) {
        BDDynamicTreeNode *subeuqipment = [[BDDynamicTreeNode alloc] init];
           if ([subEquipment.leaf isEqualToString:@"1"]) {
               subeuqipment.isDepartment = NO;
           } else {
               subeuqipment.isDepartment = YES;
           }
        subeuqipment.fatherNodeId = mainEquipment.objectId;
        subeuqipment.nodeId = subEquipment.objectId;
        subeuqipment.name = subEquipment.name;
        subeuqipment.data = @{@"name":subEquipment.name};
       [self.equipmentArr addObject:subeuqipment];
        NSString *smallUrlStr = [NSString stringWithFormat:@"api/v1/hems/equipment/tree?id=%@",subEquipment.ID];
      [XHHttpTool get:smallUrlStr params:nil success:^(id json) {
          NSArray *smallArr = [XHDepartment mj_objectArrayWithKeyValuesArray:json];
         for (XHDepartment *smallEqu in smallArr) {
             BDDynamicTreeNode *smalleuqipment = [[BDDynamicTreeNode alloc] init];
            if ([smallEqu.leaf isEqualToString:@"1"]) {
                smalleuqipment.isDepartment = NO;
              } else {
               smalleuqipment.isDepartment = YES;
                            }
           smalleuqipment.fatherNodeId = subEquipment.objectId;
           smalleuqipment.nodeId = smallEqu.objectId;
           smalleuqipment.name = smallEqu.name;
           smalleuqipment.data = @{@"name":smallEqu.name};
           [self.equipmentArr addObject:smalleuqipment];
           NSString *littltSmallUrlStr = [NSString stringWithFormat:@"api/v1/hems/equipment/tree?id=%@",smallEqu.ID];
            [XHHttpTool get:littltSmallUrlStr params:nil success:^(id json) {
              NSArray *littleSmallArr = [XHDepartment mj_objectArrayWithKeyValuesArray:json];
              for (XHDepartment *littleSmallEqu in littleSmallArr) {
                BDDynamicTreeNode *littleSmalleuqipment = [[BDDynamicTreeNode alloc] init];
               if ([littleSmallEqu.leaf isEqualToString:@"1"]) {
                    littleSmalleuqipment.isDepartment = NO;
                } else {
                   littleSmalleuqipment.isDepartment = YES;
                }
               littleSmalleuqipment.fatherNodeId = smallEqu.objectId;
               littleSmalleuqipment.nodeId = littleSmallEqu.objectId;
                littleSmalleuqipment.name = littleSmallEqu.name;
                littleSmalleuqipment.data = @{@"name":littleSmallEqu.name};
               [self.equipmentArr addObject:littleSmalleuqipment];
                NSString *tinyUrlStr = [NSString stringWithFormat:@"api/v1/hems/equipment/tree?id=%@",littleSmallEqu.ID];
                [XHHttpTool get:tinyUrlStr params:nil success:^(id json) {
                NSArray *tinyArr = [XHDepartment mj_objectArrayWithKeyValuesArray:json];
                 for (XHDepartment *tinyEqu in tinyArr) {
                  BDDynamicTreeNode *tinyeuqipment = [[BDDynamicTreeNode alloc] init];
               if ([tinyEqu.leaf isEqualToString:@"1"]) {
                tinyeuqipment.isDepartment = NO;
                                            } else {
               tinyeuqipment.isDepartment = YES;
        }
         tinyeuqipment.fatherNodeId = littleSmallEqu.objectId;
        tinyeuqipment.nodeId = tinyEqu.objectId;
          tinyeuqipment.name = tinyEqu.name;
        tinyeuqipment.data = @{@"name":tinyEqu.name};
        [self.equipmentArr addObject:tinyeuqipment];
                                        }
        [self setupUI];
                                    } failure:^(NSError *error) {
                                        
                                    }];
                                }
                                
                            } failure:^(NSError *error) {
                                
                            }];
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@--",error);
    }];
    
}

- (void)setupUI {
    _dynamicTree1 = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) nodes:self.equipmentArr];
    _dynamicTree1.delegate = self;
    [self.view addSubview:_dynamicTree1];
}
- (void)dynamicTree:(BDDynamicTree *)dynamicTree didSelectedRowWithNode:(BDDynamicTreeNode *)node
{
    if (!node.isDepartment) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"确认选择此项吗？" message:node.name preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            equipmentStr = node.name;
            equipmentID = node.nodeId;
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

- (NSMutableArray *)equipmentArr {
	if(_equipmentArr == nil) {
		_equipmentArr = [[NSMutableArray alloc] init];
	}
	return _equipmentArr;
}

- (NSMutableArray *)firstEquArr {
	if(_firstEquArr == nil) {
		_firstEquArr = [[NSMutableArray alloc] init];
	}
	return _firstEquArr;
}

@end

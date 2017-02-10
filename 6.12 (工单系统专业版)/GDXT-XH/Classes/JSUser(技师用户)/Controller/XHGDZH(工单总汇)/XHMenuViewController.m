//
//  XHMenuViewController.m
//  LSPT_SX
//
//  Created by 谢琰 on 16/2/24.
//  Copyright © 2016年 LS. All rights reserved.
//

#import "XHMenuViewController.h"
#import "XHConst.h"
@interface XHMenuViewController ()
@property (nonatomic, strong) NSArray *titles;
@end

@implementation XHMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.bounces = NO;
    self.titles = @[@"最近一周",@"最近一月",@"最近一年"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.row == 0) {
        [XHNotificationCenter postNotificationName:XHSumMenuWeekDidClickNotification object:nil];
    }else if (indexPath.row == 1) {
        [XHNotificationCenter postNotificationName:XHSumMenuMonthDidClickNotification object:nil];
    }else{
        [XHNotificationCenter postNotificationName:XHSumMenuYearDidClickNotification object:nil];
    }
}

@end

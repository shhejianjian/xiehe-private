//
//  XHSumFirstCell.m
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/19.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSumFirstCell.h"
#import "XHSubSummary.h"
#import "XHSummary.h"
@interface XHSumFirstCell()
@property (weak, nonatomic) IBOutlet UILabel *totalCountLable;
@property (weak, nonatomic) IBOutlet UILabel *avgLable;

@end
@implementation XHSumFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSummary:(XHSummary *)summary
{
    _summary = summary;
    XHSubSummary *subSummary = summary.workOrderStatus;
    self.totalCountLable.text = [NSString stringWithFormat:@"%d",subSummary.HangUp + subSummary.Arrive + subSummary.Issue + subSummary.Review + subSummary.Receive + subSummary.Distribute + subSummary.Complete];
    self.avgLable.text = [NSString stringWithFormat:@"平均响应时间:%d小时,平均完成时间:%d小时",(int)(summary.AvgArriveTime/(1000 * 60 * 60) + 0.5),(int)(summary.AvgCompleteTime/(1000 * 60 * 60) + 0.5)];
}
@end

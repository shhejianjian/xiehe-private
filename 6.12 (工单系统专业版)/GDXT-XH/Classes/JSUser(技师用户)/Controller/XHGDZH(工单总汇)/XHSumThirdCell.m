//
//  XHSumThirdCell.m
//  GDXT-XH
//
//  Created by 何键键 on 16/5/4.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSumThirdCell.h"
#import "UIView+MJExtension.h"
#import "PNChart.h"
#define SCREENWITH   [UIScreen mainScreen].bounds.size.width
@interface XHSumThirdCell ()
@property (strong, nonatomic)PNLineChart *lineChart;
@property (strong, nonatomic)PNLineChartData *dataTotal;
@property (strong, nonatomic)PNLineChartData *dataComplete;

@end

@implementation XHSumThirdCell
- (PNLineChartData *)dataComplete
{
    if (!_dataComplete) {
        _dataComplete = [PNLineChartData new];
        _dataComplete.dataTitle = @"当天工单";
        _dataComplete.color = PNTwitterColor;
        _dataComplete.alpha = 0.5f;
        _dataComplete.inflexionPointStyle = PNLineChartPointStyleCircle;
    }
    return _dataComplete;
}
- (PNLineChartData *)dataTotal
{
    if (!_dataTotal) {
        _dataTotal = [PNLineChartData new];
        _dataTotal.dataTitle = @"当天结单";
        _dataTotal.color = PNFreshGreen;
        _dataTotal.alpha = 0.3f;
        _dataTotal.inflexionPointStyle = PNLineChartPointStyleTriangle;
    }
    return _dataTotal;
}

- (PNLineChart *)lineChart
{
    if (!_lineChart) {
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 320.0)];
        _lineChart.yLabelFormat = @"%1.1f";
        _lineChart.backgroundColor = [UIColor whiteColor];
        [_lineChart strokeChart];
        _lineChart.legendStyle = PNLegendItemStyleSerial;
        _lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        _lineChart.legendFontColor = [UIColor redColor];
        _lineChart.showCoordinateAxis = YES;
        [self.contentView addSubview:self.lineChart];
    }
    return _lineChart;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setChartData:(NSArray *)chartData
{
    NSInteger maxTotal = [[chartData.firstObject valueForKeyPath:@"@max.intValue"] integerValue];
    NSInteger maxComplete = [[chartData[1] valueForKeyPath:@"@max.intValue"] integerValue];
    self.lineChart.yFixedValueMax = MAX(maxTotal, maxComplete);
    self.lineChart.xLabels = chartData.lastObject;
    self.lineChart.yLabels = [self getYLable:MAX(maxTotal, maxComplete)];
    // Line Chart #1
    NSArray * completeArray = chartData[1];
    self.dataComplete.itemCount = completeArray.count;
    self.dataComplete.getData = ^(NSUInteger index) {
        CGFloat yValue = [completeArray[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Line Chart #2
    NSArray * totalArray = chartData.firstObject;
    self.dataTotal.itemCount = totalArray.count;
    self.dataTotal.getData = ^(NSUInteger index) {
        CGFloat yValue = [totalArray[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[self.dataComplete, self.dataTotal];
    [self.lineChart strokeChart];

    UIView *legend = [self.lineChart getLegendWithMaxWidth:SCREEN_WIDTH];
    [legend setFrame:CGRectMake(legend.frame.size.width * 0.25, 345, legend.frame.size.width, legend.frame.size.width)];
    [self.contentView addSubview:legend];
  }
- (NSMutableArray *)getYLable:(NSInteger)max
{
    NSMutableArray *ylables = [[NSMutableArray alloc]init];
    NSInteger count = (NSInteger)(max/4 + 0.5);
    for (NSInteger i = 0; i <= count  ; i ++) {
        [ylables addObject:[NSString stringWithFormat:@"%d",i * 4]];
    }
    return ylables;
}

@end

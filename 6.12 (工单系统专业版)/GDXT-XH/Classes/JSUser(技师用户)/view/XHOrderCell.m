//
//  XHOrderCell.m
//  GDXT-XH
//
//  Created by 何键键 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHOrderCell.h"
#import "XHConst.h"
#import "XHOrder.h"
#import "XHMaterial.h"
#import "HyperlinksButton.h"
#import "XHOrderFrame.h"
#import "MJExtension.h"
#define XHOrderCellFont [UIFont systemFontOfSize:15]

@interface XHOrderCell()



@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *bxsjLabel;
@property (weak, nonatomic) IBOutlet UILabel *bxddLabel;
@property (weak, nonatomic) IBOutlet UILabel *wxlxLabel;
@property (weak, nonatomic) IBOutlet UILabel *wxnrLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *slryLabel;
@property (weak, nonatomic) IBOutlet UILabel *slsjLabel;

/** 派单人员 */
@property (nonatomic, weak) UILabel *distributorLable;
/** 派单时间 */
@property (nonatomic ,weak) UILabel *distributeTimeLable;

/** 接单时间 */
@property (nonatomic, weak) UILabel *receiveTimeLable;
/** 领料情况（由数组拼接而成）*/
@property (nonatomic, weak) UILabel *materialLable;
/** 到达时间 */
@property (nonatomic, weak) UILabel *arriveTimeLable;
/** 挂单时间 */
@property (nonatomic, weak) UILabel *hangUpTimeLable;
/** 结单时间 */
@property (nonatomic, weak) UILabel *completeTimeLable;


@end

@implementation XHOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];

    [self setupChildViews];

   
     // Initialization code
}

- (IBAction)callTelephoneNum:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(XHOrderCell:callTelClickButton:)]) {
        [self.delegate XHOrderCell:self callTelClickButton:sender.tag];
    }
}


- (void)callTelNum:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(XHOrderCell:callTelTwoClickButton:)]) {
        [self.delegate XHOrderCell:self callTelTwoClickButton:sender.tag];
    }
}

- (void)setupChildViews
{
    
    /** 派单人员 */
    UILabel *distributorLable = [[UILabel alloc]init];
    distributorLable.font = XHOrderCellFont;
    [self.detailView addSubview:distributorLable];
    self.distributorLable = distributorLable;
    
    /** 派单时间 */
    UILabel *distributeTimeLable = [[UILabel alloc]init];
    distributeTimeLable.font = XHOrderCellFont;
    [self.detailView addSubview:distributeTimeLable];
    self.distributeTimeLable = distributeTimeLable;
    
    /** 接单人员 */
    HyperlinksButton *receiverButton = [[HyperlinksButton alloc]init];
    receiverButton.titleLabel.font = XHOrderCellFont;
    [receiverButton setColor:XHGlobalColor];
    [receiverButton setTitleColor:XHGlobalColor forState:UIControlStateNormal];
    receiverButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [receiverButton addTarget:self action:@selector(callTelNum:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailView addSubview:receiverButton];
    self.receiverButton = receiverButton;
    
    /** 接单时间 */
    UILabel *receiveTimeLable = [[UILabel alloc]init];
    receiveTimeLable.font = XHOrderCellFont;
    [self.detailView addSubview:receiveTimeLable];
    self.receiveTimeLable = receiveTimeLable;
    
    /** 领料情况（由数组拼接而成）*/
    UILabel *materialLable = [[UILabel alloc]init];
    materialLable.font = XHOrderCellFont;
    materialLable.numberOfLines = 0;
    [self.detailView addSubview:materialLable];
    self.materialLable = materialLable;
    
    /** 到达时间 */
    UILabel *arriveTimeLable = [[UILabel alloc]init];
    arriveTimeLable.font = XHOrderCellFont;
    [self.detailView addSubview:arriveTimeLable];
    self.arriveTimeLable = arriveTimeLable;
    
    /** 挂单时间 */
    UILabel *hangUpTimeLable = [[UILabel alloc]init];
    hangUpTimeLable.font = XHOrderCellFont;
    [self.detailView addSubview:hangUpTimeLable];
    self.hangUpTimeLable = hangUpTimeLable;
    
    /** 结单时间 */
    UILabel *completeTimeLable = [[UILabel alloc]init];
    completeTimeLable.font = XHOrderCellFont;
    [self.detailView addSubview:completeTimeLable];
    self.completeTimeLable = completeTimeLable;
}
- (void)setOrderFrame:(XHOrderFrame *)orderFrame
{
     _orderFrame = orderFrame;
    XHOrder *order = orderFrame.order;
    [self updateDataWithOrder:order];
//    XHLog(@"传进来的Order%@",order.mj_keyValues);
    /** 派单人员 */
    self.distributorLable.frame = orderFrame.distributorF;
    self.distributorLable.text = [NSString stringWithFormat:@"派单人员:%@",order.distributor];
    self.distributorLable.hidden = !order.isOpened;
    
    /** 派单时间 */
    self.distributeTimeLable.frame = orderFrame.distributeTimeF;
    self.distributeTimeLable.text = [NSString stringWithFormat:@"派单时间:%@",[self covertToDateStringFromString:order.distributeTime]];
    self.distributeTimeLable.hidden = !order.isOpened;

    /** 接单人员 */
    self.receiverButton.frame = orderFrame.receiverF;
    [self.receiverButton setTitle:[NSString stringWithFormat:@"接单人员:%@",order.receiver] forState:UIControlStateNormal];
    self.receiverButton.hidden = !order.isOpened;
    
    /** 接单时间 */
    self.receiveTimeLable.frame = orderFrame.receiveTimeF;
    self.receiveTimeLable.text = [NSString stringWithFormat:@"接单时间:%@",[self covertToDateStringFromString:order.receiveTime]];
    self.receiveTimeLable.hidden = !order.isOpened;
    
    /** 领料情况（由数组拼接而成）*/
    self.materialLable.frame = orderFrame.materialF;
    self.materialLable.text = [NSString stringWithFormat:@"领料情况:%@",order.materialStr];
    self.materialLable.hidden = !order.isOpened;
    
    /** 到达时间 */
    self.arriveTimeLable.frame = orderFrame.arriveTimeF;
    self.arriveTimeLable.text = [NSString stringWithFormat:@"到达时间:%@",[self covertToDateStringFromString:order.arriveTime]];
    self.arriveTimeLable.hidden = !order.isOpened;
    
    /** 挂单时间 */
    self.hangUpTimeLable.frame = orderFrame.hangUpTimeF;
    self.hangUpTimeLable.text = [NSString stringWithFormat:@"挂单时间:%@",[self covertToDateStringFromString:order.hangUpTime]];;
    self.hangUpTimeLable.hidden = !order.isOpened;
    
    /** 结单时间 */
    self.completeTimeLable.frame = orderFrame.completeTimeF;
    self.completeTimeLable.text = [NSString stringWithFormat:@"结单时间:%@",[self covertToDateStringFromString:order.completeTime]];
    self.completeTimeLable.hidden = !order.isOpened;
}
- (void)setupUI
{
    [self.bxryBtn setColor:XHGlobalColor];
    self.lingLiaoBtn.layer.cornerRadius = 3;
    self.detailView.layer.cornerRadius = 3;
    self.detailView.layer.shadowOffset =  CGSizeMake(1, 1);
    self.detailView.layer.shadowOpacity = 0.3;
    self.detailView.layer.shadowColor =  [UIColor blackColor].CGColor;
    self.jieDanBtn.layer.cornerRadius = 3;
    self.lingLiaoBtn.layer.shadowOffset =  CGSizeMake(1, 1);
    self.lingLiaoBtn.layer.shadowOpacity = 0.3;
    self.lingLiaoBtn.layer.shadowColor =  [UIColor blackColor].CGColor;
}
/**
 *  抽出set方法中公共的代码
 *
 */
- (void)updateDataWithOrder:(XHOrder *)order
{
    [self.jieDanBtn setTitle:order.buttonTitle forState:UIControlStateNormal];
    [self.bxryBtn setTitle:[NSString stringWithFormat:@"报修人员:%@",order.requestUser] forState:UIControlStateNormal];
    self.bxsjLabel.text = [NSString stringWithFormat:@"报修时间:%@",[self covertToDateStringFromString:order.requestTime]];
    NSRange range = [order.building rangeOfString:@"/"];
    NSString *buildStr = [order.building substringToIndex:range.location];
    self.bxddLabel.text = [NSString stringWithFormat:@"报修地点:%@/%@/%@",buildStr,order.requestDepartment,order.address];
    self.wxlxLabel.text = [NSString stringWithFormat:@"维修类型:%@",order.type];
    self.wxnrLabel.text = [NSString stringWithFormat:@"维修内容:%@(%@)",order.equipment,order.faultType];
    self.timeLimitLabel.text = [NSString stringWithFormat:@"是否时限:%@",order.processingTimeLimit];
    self.slryLabel.text = [NSString stringWithFormat:@"受理人员:%@",order.issuer];
    self.slsjLabel.text = [NSString stringWithFormat:@"受理时间:%@",[self covertToDateStringFromString:order.issueTime]];
    self.slryLabel.hidden = !order.isOpened;
    self.slsjLabel.hidden = !order.isOpened;
    self.statusImageView.image = [UIImage imageNamed:order.imageUrl];
   }
- (NSString *)covertToDateStringFromString:(NSString *)Str
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[Str longLongValue]/1000.0];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}
- (IBAction)btnLingliaoClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(DJDTableViewCell:didClickButton:)]) {
        [self.delegate DJDTableViewCell:self didClickButton:XHDJDTableViewButtonLingLiao];
    }
}
- (IBAction)btnCaozuoClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(DJDTableViewCell:didClickButton:)]) {
        [self.delegate DJDTableViewCell:self didClickButton:XHDJDTableViewButtonCaozuo];
    }
}


@end

//
//  XHOrderFrame.m
//  test
//
//  Created by 谢琰 on 16/5/29.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHOrderFrame.h"
#import "XHOrder.h"

//cell的边距
#define XHOrderCellPadding 10
//这些子控件Y方向是从原始值开始计算的
#define XHOrderCellY 205
//子控件的高度
#define XHOrderCellChildViewH 18
//子控件的宽度
#define XHOrderCellChildViewW [UIScreen mainScreen].bounds.size.width - 2 * 20
//子控件之间的间距
#define XHOrderCellChildViewPadding 8
//底部按钮的高度
#define XHOrderCellButtonH 58
//cell的字体
#define XHOrderCellFont [UIFont systemFontOfSize:15]


@implementation XHOrderFrame
- (void)setOrder:(XHOrder *)order
{
    
    _order = order;
    //计算保修地点的高度(有时候一行,有时候两行)
    NSRange range = [order.building rangeOfString:@"/"];
    NSString *buildStr = [order.building substringToIndex:range.location];
    NSString *addressStr = [NSString stringWithFormat:@"报修地点:%@/%@/%@",buildStr,order.requestDepartment,order.address];
    CGSize addressSize = [addressStr boundingRectWithSize:CGSizeMake(XHOrderCellChildViewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XHOrderCellFont} context:nil].size;
    CGFloat XHOrderCellOrginalY = XHOrderCellY + addressSize.height;
    //    NSInteger count = 0;
    /** 派单人员 */
    if (order.distributor.length) {
        self.distributorF = CGRectMake(XHOrderCellPadding, XHOrderCellOrginalY, XHOrderCellChildViewW, XHOrderCellChildViewH);
        XHOrderCellOrginalY = XHOrderCellOrginalY + (XHOrderCellChildViewH + XHOrderCellChildViewPadding);
    }
    
    /** 派单时间 */
    if (order.distributeTime.length) {
        self.distributeTimeF = CGRectMake(XHOrderCellPadding, XHOrderCellOrginalY, XHOrderCellChildViewW, XHOrderCellChildViewH);
        XHOrderCellOrginalY = XHOrderCellOrginalY + (XHOrderCellChildViewH + XHOrderCellChildViewPadding);
    }
    /** 接单人员 */
    if (order.receiver.length) {
        self.receiverF = CGRectMake(XHOrderCellPadding, XHOrderCellOrginalY, XHOrderCellChildViewW, XHOrderCellChildViewH);
        XHOrderCellOrginalY = XHOrderCellOrginalY + (XHOrderCellChildViewH + XHOrderCellChildViewPadding);
    }
    /** 接单时间 */
    if (order.receiveTime.length) {
        self.receiveTimeF = CGRectMake(XHOrderCellPadding, XHOrderCellOrginalY, XHOrderCellChildViewW, XHOrderCellChildViewH);
        XHOrderCellOrginalY = XHOrderCellOrginalY + (XHOrderCellChildViewH + XHOrderCellChildViewPadding);
    }
    /** 领料情况（由数组拼接而成）*/
    if (order.materialStr.length) {
        CGSize materialSize = [order.materialStr boundingRectWithSize:CGSizeMake(XHOrderCellChildViewW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XHOrderCellFont} context:nil].size;
        self.materialF = CGRectMake(XHOrderCellPadding, XHOrderCellOrginalY, XHOrderCellChildViewW, materialSize.height);
        XHOrderCellOrginalY = XHOrderCellOrginalY + materialSize.height + XHOrderCellPadding;
    }
    
    /** 到达时间 */
    if (order.arriveTime.length) {
        self.arriveTimeF = CGRectMake(XHOrderCellPadding, XHOrderCellOrginalY, XHOrderCellChildViewW, XHOrderCellChildViewH);
        XHOrderCellOrginalY = XHOrderCellOrginalY + (XHOrderCellChildViewH + XHOrderCellChildViewPadding);
    }
    
    /** 挂单时间 */
    if (order.hangUpTime.length) {
        self.hangUpTimeF = CGRectMake(XHOrderCellPadding, XHOrderCellOrginalY, XHOrderCellChildViewW, XHOrderCellChildViewH);
        XHOrderCellOrginalY = XHOrderCellOrginalY + (XHOrderCellChildViewH + XHOrderCellChildViewPadding);
    }
    
    /** 结单时间 */
    if (order.completeTime.length) {
        self.completeTimeF = CGRectMake(XHOrderCellPadding, XHOrderCellOrginalY, XHOrderCellChildViewW, XHOrderCellChildViewH);
        XHOrderCellOrginalY = XHOrderCellOrginalY + (XHOrderCellChildViewH + XHOrderCellChildViewPadding);
    }
    
    self.cellHeight = XHOrderCellButtonH  + XHOrderCellOrginalY + 10 ;
}
@end

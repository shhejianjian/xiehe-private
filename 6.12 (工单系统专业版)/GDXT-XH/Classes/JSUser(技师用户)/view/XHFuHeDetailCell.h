//
//  XHFuHeDetailCell.h
//  GDXT-XH
//
//  Created by 何键键 on 16/5/26.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHOrder;
@interface XHFuHeDetailCell : UITableViewCell
@property (nonatomic, strong) XHOrder *detailOrder;
@property (nonatomic, strong) XHOrder *remarkOrder;
@end

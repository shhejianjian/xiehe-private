//
//  XHWarnCell.h
//  GDXT-XH
//
//  Created by 何键键 on 16/5/17.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHWarn;

@interface XHWarnCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) XHWarn *redWarn;
@property (strong, nonatomic) XHWarn *yellowWarn;

@end

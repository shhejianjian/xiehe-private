//
//  XHJieDanCenterCell.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/17.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XHJieDanCenterCellStarOne,
    XHJieDanCenterCellStarTwo,
    XHJieDanCenterCellStarThree,
    XHJieDanCenterCellStarFour,
    XHJieDanCenterCellStarFive
} XHJieDanCenterCellStar;

@class XHJieDanCenterCell;

@protocol XHJieDanCenterCellDelegate <NSObject>

@optional

- (void)jieDanCenterCell:(XHJieDanCenterCell *)cell didClickStar:(XHJieDanCenterCellStar)star;
- (void)jieDanCenterCellSignButtonDidClick:(XHJieDanCenterCell *)cell;
@end

@interface XHJieDanCenterCell : UITableViewCell
@property (nonatomic, weak) id<XHJieDanCenterCellDelegate>delegate;
@end

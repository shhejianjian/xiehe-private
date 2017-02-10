//
//  XHGuaDanCenterCell.h
//  GDXT-XH
//
//  Created by 谢琰 on 16/5/17.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHGuaDanCenterCell, XHOption;
@protocol XHGuaDanCenterCellDelegate <NSObject>
@optional

- (void)GuaDanCenterCellOptionButtonDidClick:(XHGuaDanCenterCell *)cell Option:(XHOption *)option;

@end

@interface XHGuaDanCenterCell : UITableViewCell

@property (nonatomic, weak) id<XHGuaDanCenterCellDelegate>delegate;
@property (nonatomic, copy) NSString *optionUrl;
@end

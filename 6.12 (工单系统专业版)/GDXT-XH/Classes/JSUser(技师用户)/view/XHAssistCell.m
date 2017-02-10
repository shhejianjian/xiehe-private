//
//  XHAssistCell.m
//  GDXT-XH
//
//  Created by 何键键 on 16/4/22.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHAssistCell.h"
#import "XHAssist.h"
@interface XHAssistCell()
@property (strong, nonatomic) IBOutlet UIImageView *userIcon;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userPhone;
@property (strong, nonatomic) IBOutlet UILabel *squareLabel;
@end
@implementation XHAssistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.squareLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:25];
//    self.squareLabel.text = @"\uf279";
    // Initialization code
}
- (void)setAssist:(XHAssist *)assist
{
    _assist = assist;
    if ([assist.assist isEqualToString:@"1"]) {
        self.squareLabel.textColor = [UIColor orangeColor];
        self.squareLabel.text = @"\uf26a";
    }
    else{
        self.squareLabel.textColor = [UIColor darkGrayColor];
        self.squareLabel.text = @"\uf279";
    }
    self.userPhone.text = assist.telephone;
    self.userName.text = assist.name;
}

@end

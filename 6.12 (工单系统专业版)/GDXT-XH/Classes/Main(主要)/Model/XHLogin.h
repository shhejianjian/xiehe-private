//
//  XHLogin.h
//  XHZF
//
//  Created by 何键键 on 16/4/5.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHLogin : NSObject
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *roleName;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *Date;
@property (nonatomic, copy) NSString *currentUser;
@property (nonatomic, copy) NSString *jsessionid;
@property (nonatomic, copy) NSString *shiroLoginFailure;
@end

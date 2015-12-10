//
//  GVUserDefaults+ZXUtil.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (ZXUtil)
/**
 *  ZXAccount to dictionary
 */
@property (nonatomic , strong) NSDictionary *account;
/**
 *  ZXUser to dictionary
 */
@property (nonatomic , strong) NSDictionary *user;
@property (nonatomic , assign) BOOL isLogin;

/**
 *  密码
 */
@property (nonatomic , copy) NSString *password;

@property (nonatomic , assign) long selectedCid;
@end

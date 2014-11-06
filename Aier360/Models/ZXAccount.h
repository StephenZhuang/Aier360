//
//  ZXAccount.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"
#import "ZXUser.h"
#import "ZXSchool.h"
#import "ZXAppStateInfo.h"

@interface ZXAccount : BaseModel
@property (nonatomic , copy) NSString *account;
@property (nonatomic , strong) NSArray *appStateInfolist;
@property (nonatomic , strong) NSArray *adminClassList;
@property (nonatomic , copy) NSString *appStatus;
@property (nonatomic , strong) NSArray *classList;
@property (nonatomic , assign) NSInteger counts;
@property (nonatomic , copy) NSString *error_info;
@property (nonatomic , strong) NSDictionary *hasEntrances;
@property (nonatomic , assign) NSInteger online;
@property (nonatomic , copy) NSString *pwd;
@property (nonatomic , strong) NSArray *schoolList;
@property (nonatomic , assign) NSInteger sid;
@property (nonatomic , assign) NSInteger tid;
@property (nonatomic , assign) NSInteger uid;

@property (nonatomic , strong) ZXUser *user;
@end

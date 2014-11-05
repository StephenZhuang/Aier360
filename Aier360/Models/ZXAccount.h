//
//  ZXAccount.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "BaseModel.h"
#import "ZXUser.h"

@interface ZXAccount : BaseModel
@property (nonatomic , copy) NSString *account;
@property (nonatomic , strong) NSMutableArray *appStateInfolist;
@property (nonatomic , strong) NSMutableArray *adminClassList;
@property (nonatomic , copy) NSString *appStatus;
@property (nonatomic , strong) NSMutableArray *classList;
@property (nonatomic , assign) NSInteger counts;
@property (nonatomic , copy) NSString *errorInfo;
@property (nonatomic , strong) NSDictionary *hasEntrances;
@property (nonatomic , assign) NSInteger online;
@property (nonatomic , copy) NSString *pwd;
@property (nonatomic , strong) NSMutableArray *schoolList;
@property (nonatomic , assign) NSInteger sid;
@property (nonatomic , assign) NSInteger tid;
@property (nonatomic , assign) NSInteger uid;

@property (nonatomic , strong) ZXUser *user;
@end

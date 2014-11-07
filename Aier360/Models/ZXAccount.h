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
/**
 *  App端所有用户的权限列表（包括管理员以及非管理员用户）
 */
@property (nonatomic , strong) NSArray *appStateInfolist;
/**
 *  用户所在班级
 */
@property (nonatomic , strong) NSArray *classList;
/**
 *  用户所在学校
 */
@property (nonatomic , strong) NSArray *schoolList;
/**
 *  用户
 */
@property (nonatomic , strong) ZXUser *user;

@property (nonatomic , copy) NSString *account;
//@property (nonatomic , strong) NSArray *adminClassList;
//@property (nonatomic , copy) NSString *appStatus;
//@property (nonatomic , assign) NSInteger counts;
//@property (nonatomic , strong) NSDictionary *hasEntrances;
//@property (nonatomic , assign) NSInteger online;
//@property (nonatomic , copy) NSString *pwd;
//@property (nonatomic , assign) NSInteger sid;
//@property (nonatomic , assign) NSInteger tid;
//@property (nonatomic , assign) NSInteger uid;
@end

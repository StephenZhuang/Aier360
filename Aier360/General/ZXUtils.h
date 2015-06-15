//
//  ZXUtils.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXAccount.h"
#import "ZXAppStateInfo.h"
#import "ZXMessageExtension.h"


#define HASIdentytyWithCid(identity,cid) ([[ZXUtils sharedInstance] hasIdentity:identity inClass:cid])
#define HASIdentyty(identity) ([[ZXUtils sharedInstance] hasIdentity:identity])
#define GLOBAL_UID ([ZXUtils sharedInstance].user.uid)
/**
 *  身份
 */
typedef NS_ENUM(NSUInteger, ZXIdentity){
    /**
     *  学校管理员
     */
    ZXIdentitySchoolMaster = 1,
    /**
     *  班级管理员
     */
    ZXIdentityClassMaster = 2,
    /**
     *  教师
     */
    ZXIdentityTeacher = 3,
    /**
     *  家长
     */
    ZXIdentityParent = 4,
    /**
     *  没有身份
     */
    ZXIdentityNone = 5,
    /**
     *  行政，后勤
     */
    ZXIdentityStaff = 6,
    /**
     *  有身份，没选择
     */
    ZXIdentityUnchoosesd = 7
};

@interface ZXUtils : NSObject
@property (nonatomic , strong) ZXUser *user;
@property (nonatomic , strong) ZXAccount *account;
@property (nonatomic , strong) ZXSchool *currentSchool;
@property (nonatomic , strong) ZXMessageExtension *messageExtension;
@property (nonatomic , strong) NSDictionary *controllerNameDictionary;
+ (instancetype)sharedInstance;
- (BOOL)hasIdentity:(ZXIdentity)identity inClass:(long)cid;
- (BOOL)hasIdentity:(ZXIdentity)identity;
@end

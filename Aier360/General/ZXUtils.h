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

typedef NS_ENUM(NSUInteger, ZXIdentity) {
    ZXIdentitySchoolMaster = 1,
    ZXIdentityClassMaster = 2,
    ZXIdentityTeacher = 3,
    ZXIdentityParent = 4,
    ZXIdentityNone = 5,
    ZXIdentityStaff = 6,
    ZXIdentityUnchoosesd = 7
};

@interface ZXUtils : NSObject
@property (nonatomic , strong) ZXUser *user;
@property (nonatomic , strong) ZXAccount *account;
@property (nonatomic , strong) ZXSchool *currentSchool;
@property (nonatomic , strong) ZXClass *currentClass;
@property (nonatomic , strong) ZXAppStateInfo *currentAppStateInfo;
@property (nonatomic , assign) ZXIdentity identity;
+ (instancetype)sharedInstance;
@end

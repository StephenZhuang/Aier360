//
//  ZXPersonalDynamic.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/27.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZXBaseDynamic.h"

@class ZXBaseDynamic, ZXManagedUser;

@interface ZXPersonalDynamic : ZXBaseDynamic
/**
 *  个人动态权限（1：所有人可见 2：仅好友 3：仅自己可见）
 */
@property (nonatomic) int16_t authority;
/**
 *  babyBirthdays
 */
@property (nonatomic, retain) NSString * babyBirthdays;
/**
 *  原创动态
 */
@property (nonatomic, retain) ZXBaseDynamic *dynamic;
/**
 *  用户
 */
@property (nonatomic, retain) ZXManagedUser *user;

/**
 *  班级名
 */
@property (nonatomic, retain) NSString * tname;

/**
 *  学校id
 */
@property (nonatomic) int32_t sid;

/**
 *  班级id
 */
@property (nonatomic) int32_t cid;

- (void)updateWithDic:(NSDictionary *)dic save:(BOOL)save;
@end

//
//  ZXSchoolDynamic.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/27.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZXManagedUser.h"

@class ZXManagedUser;

@interface ZXSchoolDynamic : NSManagedObject
/**
 *  班级id
 */
@property (nonatomic) int64_t cid;
/**
 *  学校id
 */
@property (nonatomic) int16_t sid;
/**
 *  发布动态的老师的姓名
 */
@property (nonatomic, retain) NSString * tname;
/**
 *  用户
 */
@property (nonatomic, retain) ZXManagedUser *user;

@end

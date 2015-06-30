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

@class ZXManagedUser;

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
@property (nonatomic, retain) ZXPersonalDynamic *dynamic;
/**
 *  用户
 */
@property (nonatomic, retain) ZXManagedUser *user;

/**
 *  班级名
 */
@property (nonatomic, retain) NSString * tname;

/**
 *  班级名称
 */
@property (nonatomic, retain) NSString * cname;

/**
 *  学校id
 */
@property (nonatomic) int32_t sid;

/**
 *  班级id
 */
@property (nonatomic) int32_t cid;

/**
 *  类型 0修改，1新增，-2删除
 */
@property (nonatomic) int16_t ctype;

@property (nonatomic) Boolean isTemp;

@property (nonatomic, retain) NSSet *repostDynamics;

- (void)updateWithDic:(NSDictionary *)dic save:(BOOL)save;
@end

@interface ZXPersonalDynamic (CoreDataGeneratedAccessors)

- (void)addRepostDynamicsObject:(ZXPersonalDynamic *)value;
- (void)removeRepostDynamicsObject:(ZXPersonalDynamic *)value;
- (void)addRepostDynamics:(NSSet *)values;
- (void)removeRepostDynamics:(NSSet *)values;

@end

//
//  ZXManagedUser.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/27.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, ZXSchoolDynamic;

@interface ZXManagedUser : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * aier;
@property (nonatomic, retain) NSString * headimg;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic) int64_t uid;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * city;
@property (nonatomic) int32_t city_id;
@property (nonatomic, retain) NSString * desinfo;
@property (nonatomic, retain) NSString * ht;
@property (nonatomic) int32_t ht_id;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSSet *personalDynamics;
@property (nonatomic, retain) NSSet *schoolDynamics;
@end

@interface ZXManagedUser (CoreDataGeneratedAccessors)

- (void)addPersonalDynamicsObject:(NSManagedObject *)value;
- (void)removePersonalDynamicsObject:(NSManagedObject *)value;
- (void)addPersonalDynamics:(NSSet *)values;
- (void)removePersonalDynamics:(NSSet *)values;

- (void)addSchoolDynamicsObject:(ZXSchoolDynamic *)value;
- (void)removeSchoolDynamicsObject:(ZXSchoolDynamic *)value;
- (void)addSchoolDynamics:(NSSet *)values;
- (void)removeSchoolDynamics:(NSSet *)values;

@end

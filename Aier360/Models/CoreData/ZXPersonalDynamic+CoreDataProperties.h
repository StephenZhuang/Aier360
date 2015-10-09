//
//  ZXPersonalDynamic+CoreDataProperties.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/22.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ZXPersonalDynamic.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXPersonalDynamic (CoreDataProperties)
/**
 *  个人动态权限（1：所有人可见 2：仅好友 3：仅自己可见）
 */
@property (nonatomic) int16_t authority;
/**
 *  宝宝生日
 */
@property (nullable, nonatomic, retain) NSString *babyBirthdays;
/**
 *  班级id
 */
@property (nonatomic) int32_t cid;
/**
 *  班级名称
 */
@property (nullable, nonatomic, retain) NSString *cname;
/**
 *  0修改1新增-2删除
 */
@property (nonatomic) int16_t ctype;
/**
 *  是否是临时的
 */
@property (nonatomic) BOOL isTemp;
/**
 *  学校id
 */
@property (nonatomic) int32_t sid;
/**
 *  发布动态的老师的姓名
 */
@property (nullable, nonatomic, retain) NSString *tname;
/**
 *  发布动态所在地区
 */
@property (nullable, nonatomic, retain) NSString *address;
/**
 *  纬度
 */
@property (nullable, nonatomic, retain) NSString *latitude;
/**
 *  经度
 */
@property (nullable, nonatomic, retain) NSString *longitude;
/**
 *  原创动态
 */
@property (nullable, nonatomic, retain) ZXPersonalDynamic *dynamic;
@property (nullable, nonatomic, retain) NSSet<ZXPersonalDynamic *> *repostDynamics;
/**
 *  用户
 */
@property (nullable, nonatomic, retain) ZXManagedUser *user;
/**
 *  广场标签
 */
@property (nullable, nonatomic, retain) NSOrderedSet<ZXSquareLabel *> *squareLabels;

@end

@interface ZXPersonalDynamic (CoreDataGeneratedAccessors)

- (void)addRepostDynamicsObject:(ZXPersonalDynamic *)value;
- (void)removeRepostDynamicsObject:(ZXPersonalDynamic *)value;
- (void)addRepostDynamics:(NSSet<ZXPersonalDynamic *> *)values;
- (void)removeRepostDynamics:(NSSet<ZXPersonalDynamic *> *)values;

- (void)insertObject:(ZXSquareLabel *)value inSquareLabelsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSquareLabelsAtIndex:(NSUInteger)idx;
- (void)insertSquareLabels:(NSArray<ZXSquareLabel *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSquareLabelsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSquareLabelsAtIndex:(NSUInteger)idx withObject:(ZXSquareLabel *)value;
- (void)replaceSquareLabelsAtIndexes:(NSIndexSet *)indexes withSquareLabels:(NSArray<ZXSquareLabel *> *)values;
- (void)addSquareLabelsObject:(ZXSquareLabel *)value;
- (void)removeSquareLabelsObject:(ZXSquareLabel *)value;
- (void)addSquareLabels:(NSOrderedSet<ZXSquareLabel *> *)values;
- (void)removeSquareLabels:(NSOrderedSet<ZXSquareLabel *> *)values;

@end

NS_ASSUME_NONNULL_END

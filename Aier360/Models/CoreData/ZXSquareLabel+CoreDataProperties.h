//
//  ZXSquareLabel+CoreDataProperties.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/22.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ZXSquareLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZXSquareLabel (CoreDataProperties)
/**
 *  创建时间
 */
@property (nullable, nonatomic, retain) NSString *ctime;
/**
 *  是否已经删除
 */
@property (nonatomic) BOOL deleted;
/**
 *  主键
 */
@property (nonatomic) int32_t id;
/**
 *  图片名称
 */
@property (nullable, nonatomic, retain) NSString *img;
/**
 *  广场标签名称
 */
@property (nullable, nonatomic, retain) NSString *name;
/**
 *  序号
 */
@property (nonatomic) int32_t sort;
/**
 *  描述
 */
@property (nullable, nonatomic, retain) NSString *desc;
@property (nonatomic) BOOL isSelected;
@property (nullable, nonatomic, retain) NSSet<ZXPersonalDynamic *> *dynamics;

@end

@interface ZXSquareLabel (CoreDataGeneratedAccessors)

- (void)addDynamicsObject:(ZXPersonalDynamic *)value;
- (void)removeDynamicsObject:(ZXPersonalDynamic *)value;
- (void)addDynamics:(NSSet<ZXPersonalDynamic *> *)values;
- (void)removeDynamics:(NSSet<ZXPersonalDynamic *> *)values;

@end

NS_ASSUME_NONNULL_END

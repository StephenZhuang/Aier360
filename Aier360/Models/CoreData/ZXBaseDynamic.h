//
//  ZXBaseDynamic.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/27.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZXPersonalDynamic;

@interface ZXBaseDynamic : NSManagedObject
/**
 *  评论的次数
 */
@property (nonatomic) int32_t ccount;
/**
 *  发布时间
 */
@property (nonatomic, retain) NSString * cdate;
/**
 *  动态内容
 */
@property (nonatomic, retain) NSString * content;
/**
 *  主键
 */
@property (nonatomic) int32_t did;
/**
 *  动态的图片
 */
@property (nonatomic, retain) NSString * img;
/**
 *  是否是原创（0原创1转发）
 */
@property (nonatomic) int16_t original;
/**
 *  赞的次数
 */
@property (nonatomic) int32_t pcount;
/**
 *  原创动态的id
 */
@property (nonatomic) int32_t relativeid;
/**
 *  转发的次数
 */
@property (nonatomic) int32_t tcount;
/**
 *  类型（1校园动态2班级动态3个人动态）
 */
@property (nonatomic) int16_t type;
/**
 *  发布动态的用户id
 */
@property (nonatomic) int32_t uid;
@property (nonatomic, retain) NSSet *personalDynamic;
@end

@interface ZXBaseDynamic (CoreDataGeneratedAccessors)

- (void)addPersonalDynamicObject:(ZXPersonalDynamic *)value;
- (void)removePersonalDynamicObject:(ZXPersonalDynamic *)value;
- (void)addPersonalDynamic:(NSSet *)values;
- (void)removePersonalDynamic:(NSSet *)values;

@end

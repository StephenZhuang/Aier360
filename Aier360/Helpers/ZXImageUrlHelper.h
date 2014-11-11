//
//  ZXImageUrlHelper.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXImageUrlHelper : NSObject
/**
 *  头像
 */
+ (NSURL *)imageUrlForHeadImg:(NSString *)imageName;
/**
 *  学校logo
 */
+ (NSURL *)imageUrlForSchoolLogo:(NSString *)imageName;
/**
 *  作业
 */
+ (NSURL *)imageUrlForHomework:(NSString *)imageName;
/**
 *  公告 ，动态
 */
+ (NSURL *)imageUrlForFresh:(NSString *)imageName;
/**
 *  每日餐饮
 */
+ (NSURL *)imageUrlForEat:(NSString *)imageName;
@end

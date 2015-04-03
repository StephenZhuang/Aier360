//
//  ZXImageUrlHelper.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZXImageType) {
    /**
     *  头像
     */
    ZXImageTypeHeadImg,
    /**
     *  学校logo
     */
    ZXImageTypeSchoolLogo,
    /**
     *  亲子任务
     */
    ZXImageTypeHomework,
    /**
     *  公告 ，动态
     */
    ZXImageTypeFresh,
    /**
     *  每日餐饮
     */
    ZXImageTypeEat,
    /**
     *  二维码
     */
    ZXImageTypeQrcode
};

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
 *  亲子任务
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
/**
 *  二维码
 */
+ (NSURL *)imageUrlForQrcode:(NSString *)imageName;

+ (NSURL *)imageUrlForType:(ZXImageType)type imageName:(NSString *)imageName;
@end

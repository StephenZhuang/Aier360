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

    ZXImageTypeSmall,

    ZXImageTypebig,

    ZXImageTypeOrigin
};

@interface ZXImageUrlHelper : NSObject
/**
 *  头像
 */
+ (NSURL *)imageUrlForHeadImg:(NSString *)imageName;

+ (NSURL *)imageUrlForSmall:(NSString *)imageName;

+ (NSURL *)imageUrlForBig:(NSString *)imageName;

+ (NSURL *)imageUrlForOrigin:(NSString *)imageName;

+ (NSURL *)imageUrlForType:(ZXImageType)type imageName:(NSString *)imageName;

/**
 *  标签图片
 */
+ (NSURL *)imageUrlForSquareLabel:(NSString *)imageName type:(ZXImageType)type;
@end

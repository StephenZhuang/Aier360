//
//  ZXImageUrlHelper.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZXImageUrlHelper : NSObject
+ (NSURL *)imageUrlForHeadImg:(NSString *)imageName;
+ (NSURL *)imageUrlForSchoolLogo:(NSString *)imageName;
+ (NSURL *)imageUrlForHomework:(NSString *)imageName;
+ (NSURL *)imageUrlForFresh:(NSString *)imageName;
+ (NSURL *)imageUrlForEat:(NSString *)imageName;
@end

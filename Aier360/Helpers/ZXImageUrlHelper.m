//
//  ZXImageUrlHelper.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXImageUrlHelper.h"

@implementation ZXImageUrlHelper
NSString *const BaseImageUrl = @"http://timg.aier360.com/";

+ (NSURL *)imageUrlForHeadImg:(NSString *)imageName
{
    NSString *path = @"headimg/big/";
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BaseImageUrl , path ,imageName]];
}

+ (NSURL *)imageUrlForSchoolLogo:(NSString *)imageName
{
    NSString *path = @"schoollogo/big/";
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BaseImageUrl , path ,imageName]];
}

+ (NSURL *)imageUrlForHomework:(NSString *)imageName
{
    NSString *path = @"homework/big/";
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BaseImageUrl , path ,imageName]];
}

+ (NSURL *)imageUrlForFresh:(NSString *)imageName
{
    NSString *path = @"fresh/big/";
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BaseImageUrl , path ,imageName]];
}

+ (NSURL *)imageUrlForEat:(NSString *)imageName
{
    NSString *path = @"caipu/big/";
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BaseImageUrl , path ,imageName]];
}
@end

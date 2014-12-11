//
//  ZXImageUrlHelper.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXImageUrlHelper.h"

@implementation ZXImageUrlHelper

#if DEBUG
NSString *const BaseImageUrl = @"http://192.168.10.202:8080/aier360/img/v1/";
#else
NSString *const BaseImageUrl = @"http://timg.aier360.com/";
#endif

+ (NSURL *)imageUrlForHeadImg:(NSString *)imageName
{
    NSString *path = @"headimg/big/";
    return [self imageUrlWithPath:path imageName:imageName];
}

+ (NSURL *)imageUrlForSchoolLogo:(NSString *)imageName
{
    NSString *path = @"schoollogo/big/";
    return [self imageUrlWithPath:path imageName:imageName];
}

+ (NSURL *)imageUrlForHomework:(NSString *)imageName
{
    NSString *path = @"homework/big/";
    return [self imageUrlWithPath:path imageName:imageName];
}

+ (NSURL *)imageUrlForFresh:(NSString *)imageName
{
    NSString *path = @"fresh/big/";
    return [self imageUrlWithPath:path imageName:imageName];
}

+ (NSURL *)imageUrlForEat:(NSString *)imageName
{
    NSString *path = @"caipu/big/";
    return [self imageUrlWithPath:path imageName:imageName];
}

+ (NSURL *)imageUrlWithPath:(NSString *)path imageName:(NSString *)imageName
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BaseImageUrl , path ,imageName]];
    NSLog(@"imageurl = %@",url.absoluteString );
    return url;
}
@end

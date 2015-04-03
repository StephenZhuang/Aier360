//
//  ZXImageUrlHelper.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXImageUrlHelper.h"

@implementation ZXImageUrlHelper

NSString *const BaseImageUrl = @"http://192.168.0.18/";
//NSString *const BaseImageUrl = @"http://timg.aier360.com/";

+ (NSURL *)imageUrlForType:(ZXImageType)type imageName:(NSString *)imageName
{
    NSURL *url = nil;
    switch (type) {
        case ZXImageTypeHeadImg:
            url = [self imageUrlForHeadImg:imageName];
            break;
        case ZXImageTypeSchoolLogo:
            url = [self imageUrlForSchoolLogo:imageName];
            break;
        case ZXImageTypeHomework:
            url = [self imageUrlForHomework:imageName];
            break;
        case ZXImageTypeFresh:
            url = [self imageUrlForFresh:imageName];
            break;
        case ZXImageTypeEat:
            url = [self imageUrlForEat:imageName];
            break;
        case ZXImageTypeQrcode:
            url = [self imageUrlForQrcode:imageName];
            break;
        default:
            url = [self imageUrlForHeadImg:imageName];
            break;
    }
    return url;
}

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

+ (NSURL *)imageUrlForQrcode:(NSString *)imageName
{
    NSString *path = @"QrCode/";
    return [self imageUrlWithPath:path imageName:imageName];
}

+ (NSURL *)imageUrlWithPath:(NSString *)path imageName:(NSString *)imageName
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BaseImageUrl , path ,imageName]];
#ifdef DEBUG
    NSLog(@"imageurl = %@",url.absoluteString );
#endif
    return url;
}
@end

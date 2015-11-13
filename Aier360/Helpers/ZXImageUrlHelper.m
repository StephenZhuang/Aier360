//
//  ZXImageUrlHelper.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXImageUrlHelper.h"

@implementation ZXImageUrlHelper

//NSString *const BaseImageUrl = @"http://192.168.1.253:8090/aierbon/img/v1/";
NSString *const BaseImageUrl = @"http://timg.aierbon.com/";

+ (NSURL *)imageUrlForType:(ZXImageType)type imageName:(NSString *)imageName
{
    NSString *style = @"";
    switch (type) {
        case ZXImageTypeHeadImg: {
            style = @"@!small";
            break;
        }
        case ZXImageTypeSmall: {
            style = @"@!small";
            break;
        }
        case ZXImageTypebig: {
            style = @"@!big";
            break;
        }
        case ZXImageTypeOrigin: {
            style = @"";
            break;
        }
        default: {
            break;
        }
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",BaseImageUrl ,imageName,style]];
    return url;
}

+ (NSURL *)imageUrlForHeadImg:(NSString *)imageName
{
    return [self imageUrlForType:ZXImageTypeHeadImg imageName:imageName];
}

+ (NSURL *)imageUrlForSmall:(NSString *)imageName
{
    return [self imageUrlForType:ZXImageTypeSmall imageName:imageName];
}

+ (NSURL *)imageUrlForBig:(NSString *)imageName
{
    return [self imageUrlForType:ZXImageTypebig imageName:imageName];
}

+ (NSURL *)imageUrlForOrigin:(NSString *)imageName
{
    return [self imageUrlForType:ZXImageTypeOrigin imageName:imageName];
}

+ (NSURL *)imageUrlForSquareLabel:(NSString *)imageName type:(ZXImageType)type
{
    NSString *style = @"";
    switch (type) {
        case ZXImageTypeHeadImg: {
            style = @"small";
            break;
        }
        case ZXImageTypeSmall: {
            style = @"small";
            break;
        }
        case ZXImageTypebig: {
            style = @"big";
            break;
        }
        case ZXImageTypeOrigin: {
            style = @"origin";
            break;
        }
        default: {
            break;
        }
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@squareLabel/%@/%@",BaseImageUrl ,style,imageName]];
    return url;
}
@end

//
//  NSString+ZXLazy.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "NSString+ZXNumber.h"

@implementation NSString (ZXNumber)
+ (NSString *)stringWithIntger:(NSInteger)integer
{
    return [NSString stringWithFormat:@"%i",integer];
}

- (NSString *)stringValue
{
    if (self) {
        return self;
    } else {
        return @"";
    }
}
@end

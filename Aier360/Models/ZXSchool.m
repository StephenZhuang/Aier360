//
//  ZXSchool.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/6.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchool.h"
#import "ZXHonor.h"

@implementation ZXSchool
- (NSDictionary *)objectClassInArray
{
    return @{@"classList" : [ZXClass class],
             @"honor" : [ZXHonor class]};
}
@end

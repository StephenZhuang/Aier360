//
//  ZXUmengHelper.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/2.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUmengHelper.h"

@implementation ZXUmengHelper
+ (void)logShare
{
    [MobClick event:@"share"];
}

+ (void)logFav
{
    [MobClick event:@"fav"];
}

+ (void)logComment
{
    [MobClick event:@"comment"];
}
@end

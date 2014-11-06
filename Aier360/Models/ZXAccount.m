//
//  ZXAccount.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAccount.h"

@implementation ZXAccount

- (NSDictionary *)objectClassInArray
{
    return @{@"schoolList" : [ZXSchool class],
             @"classList" : [ZXClass class],
             @"appStateInfolist" : [ZXAppStateInfo class]
             };
}
@end

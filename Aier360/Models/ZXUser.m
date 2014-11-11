//
//  ZXUser.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUser.h"

@implementation ZXUser
- (NSDictionary *)objectClassInArray
{
    return @{@"commonFollow" : [ZXUser class]
             };
}
@end

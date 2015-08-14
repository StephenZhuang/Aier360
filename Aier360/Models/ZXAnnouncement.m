//
//  ZXAnnouncement.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncement.h"

@implementation ZXAnnouncement
- (NSDictionary *)objectClassInArray
{
    return @{@"unReadedParents" : [ZXUser class],
             @"unReadedTeachers" : [ZXUser class]
             };
}
@end

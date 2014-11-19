//
//  ZXAnnounceRead.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnounceRead.h"

@implementation ZXAnnounceRead
- (NSDictionary *)objectClassInArray
{
    return @{@"readedParentList" : [ZXParent class],
             @"readedTeacherList" : [ZXTeacher class]
             };
}
@end

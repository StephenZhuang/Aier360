//
//  ZXTeacherNew.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherNew.h"
#import "ZXClass.h"

@implementation ZXTeacherNew
- (NSDictionary *)objectClassInArray
{
    return @{@"classes" : [ZXClass class]
             };
}
@end

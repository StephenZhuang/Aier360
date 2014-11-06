//
//  ZXSchool.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/6.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchool.h"

@implementation ZXSchool
//+ (NSDictionary *)JSONKeyPathsByPropertyKey {
//    return @{
//             @"identifier": @"id",
//             @"numTeacher": @"num_teacher",
//             @"numStudent": @"num_student",
//             @"numParent": @"num_parent"
//             };
//}
- (NSDictionary *)objectClassInArray
{
    return @{@"classList" : [ZXClass class]};
}
@end

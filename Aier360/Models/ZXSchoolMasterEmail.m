//
//  ZXSchoolMasterEmail.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolMasterEmail.h"

@implementation ZXSchoolMasterEmail
- (NSDictionary *)objectClassInArray
{
    return @{@"smeList" : [ZXSchoolMasterEmailDetail class]};
}
@end

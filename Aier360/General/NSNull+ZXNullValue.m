//
//  NSNull+ZXNullValue.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/9.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "NSNull+ZXNullValue.h"

@implementation NSNull (ZXNullValue)
- (NSInteger)integerValue
{
    return 0;
}

- (long)longValue
{
    return 0;
}

- (NSString *)stringValue
{
    return @"";
}

- (BOOL)boolValue
{
    return NO;
}

- (id)objectForKey:(NSString *)key
{
    return @"";
}
@end

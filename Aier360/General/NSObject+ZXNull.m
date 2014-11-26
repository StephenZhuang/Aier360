//
//  NSObject+ZXNull.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/26.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "NSObject+ZXNull.h"

@implementation NSObject (ZXNull)
- (BOOL)isNull
{
    return self == nil || [self isEqual:[NSNull null]];
}
@end

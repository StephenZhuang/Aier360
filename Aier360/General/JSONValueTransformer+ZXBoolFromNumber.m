//
//  JSONValueTransformer+ZXBoolFromNumber.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "JSONValueTransformer+ZXBoolFromNumber.h"

@implementation JSONValueTransformer (ZXBoolFromNumber)
- (NSNumber *)BOOLFromNSNumber:(NSNumber *)number {
    if (number.integerValue == 1) {
        return [NSNumber numberWithBool:YES];
    } else {
        return [NSNumber numberWithBool:NO];
    }
}

- (NSNumber *)BOOLFromNSString:(NSString *)string
{
    if (string.integerValue == 1) {
        return [NSNumber numberWithBool:YES];
    } else {
        return [NSNumber numberWithBool:NO];
    }
}
@end

//
//  NSJSONSerialization+ZXString.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "NSJSONSerialization+ZXString.h"

@implementation NSJSONSerialization (ZXString)
+ (NSString *)stringWithJSONObject:(id)JSONObject
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSONObject options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}
@end

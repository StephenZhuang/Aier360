//
//  NSNull+ZXNullValue.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/9.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+ZXNumber.h"

@interface NSNull (ZXNullValue)
- (NSInteger)integerValue;
- (long)longValue;
- (NSString *)stringValue;
- (id)objectForKey:(NSString *)key;
- (BOOL)boolValue;
@end

//
//  NSNull+ZXNullValue.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/9.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (ZXNullValue)
- (NSInteger)integerValue;
- (long)longValue;
- (NSString *)stringValue;
@end

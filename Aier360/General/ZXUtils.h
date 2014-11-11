//
//  ZXUtils.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXAccount.h"

@interface ZXUtils : NSObject
@property (nonatomic , strong) ZXAccount *account;
+ (instancetype)sharedInstance;
@end

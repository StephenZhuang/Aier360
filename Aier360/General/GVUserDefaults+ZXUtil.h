//
//  GVUserDefaults+ZXUtil.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "GVUserDefaults.h"
#import "ZXAccount.h"

@interface GVUserDefaults (ZXUtil)
@property (nonatomic , strong) ZXAccount *account;
@end

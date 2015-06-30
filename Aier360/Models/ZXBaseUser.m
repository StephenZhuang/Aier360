//
//  ZXBaseUser.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/15.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseUser.h"

@implementation ZXBaseUser
- (NSString *)displayName
{
    if (self.remark.length > 0) {
        return self.remark;
    }
    return self.nickname;
}
@end

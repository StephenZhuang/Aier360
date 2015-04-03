//
//  ZXFriend.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/1.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFriend.h"


@implementation ZXFriend

@dynamic fid;
@dynamic uid;
@dynamic fuid;
@dynamic state;
@dynamic remark;
@dynamic cdate;
@dynamic nickname;
@dynamic headimg;
@dynamic type;
@dynamic babyNicknames;
@dynamic babyBirthdays;
@dynamic fgName;
@dynamic pinyin;
@dynamic firstLetter;
@dynamic aier;
@dynamic account;

- (NSString *)displayName
{
    if (self.remark.length > 0) {
        return self.remark;
    } else {
        return self.nickname;
    }
}

@end

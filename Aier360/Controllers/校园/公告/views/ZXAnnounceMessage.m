//
//  ZXAnnounceMessage.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/11.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnounceMessage.h"

@implementation ZXAnnounceMessage
+ (NSInteger)getMessageNumWithTextlength:(NSInteger)length
{
    //y = 62 + (x-1) * 67
    if (length <= 65) {
        return 1;
    } else {
        NSInteger num = ceilf((length - 62) / 67.0) + 1;
        return num;
    }
}
@end

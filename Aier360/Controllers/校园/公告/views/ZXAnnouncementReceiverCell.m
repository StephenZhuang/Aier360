//
//  ZXAnnouncementReceiverCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementReceiverCell.h"

@implementation ZXAnnouncementReceiverCell
- (void)configureWithAnnouncement:(ZXAnnouncement *)announcement isReceiver:(BOOL)isReceiver
{
    if (isReceiver) {
        [self.titleLabel setText:@"收件人:"];
        if (announcement.type == 0) {
            [self.namesLabel setText:@"全体师生"];
        } else if (announcement.type == 1) {
            [self.namesLabel setText:@"班级公告"];
        } else if (announcement.type == 2) {
            [self.namesLabel setText:@"全体教师"];
        } else {
            [self.namesLabel setText:announcement.tnames];
        }
        [self.namesLabel setTextColor:[UIColor colorWithRed:161/255.0 green:157/255.0 blue:148/255.0 alpha:1.0]];
    } else {
        [self.titleLabel setText:@"发件人:"];
        [self.namesLabel setText:announcement.name_teacher];
        [self.namesLabel setTextColor:[UIColor colorWithRed:41/255.0 green:152/255.0 blue:130/255.0 alpha:1.0]];
    }
}
@end

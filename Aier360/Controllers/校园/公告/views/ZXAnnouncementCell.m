//
//  ZXAnnouncementCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementCell.h"
#import "ZXTimeHelper.h"

@implementation ZXAnnouncementCell
- (void)configureCellWithAnnouncement:(ZXAnnouncement *)announcement
{
    [self.titleLabel setText:announcement.title];
    [self.contentLabel setText:announcement.message];
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:announcement.ctime]];
    [self.readingLabel setText:[NSString stringWithFormat:@"%@人阅读",@(announcement.reading)]];
    [self.headButton sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:announcement.headimg_teacher] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_default"]];
}
@end

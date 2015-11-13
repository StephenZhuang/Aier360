//
//  ZXAnnouncementCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementCell.h"
#import "ZXTimeHelper.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>

@implementation ZXAnnouncementCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.readingProgress setProgressImage:[[UIImage imageNamed:@"announcement_progress_progress"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)]];
    [self.readingProgress setTrackImage:[UIImage imageNamed:@"announcement_progress_track"]];
}

- (void)configureCellWithAnnouncement:(ZXAnnouncement *)announcement
{
    [self.titleLabel setText:announcement.title];
    [self.contentLabel setText:announcement.message];
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:announcement.ctime]];
    
    if (announcement.shouldReaderNumber == 0 || !HASIdentyty(ZXIdentitySchoolMaster)) {
        self.readingProgressView.fd_collapsed = YES;
        if (HASIdentyty(ZXIdentitySchoolMaster)) {
            self.allReadingImage.hidden = NO;
        } else {
            self.allReadingImage.hidden = YES;
        }
    } else {
        float progress = announcement.reading * 1.0 / announcement.shouldReaderNumber;
        if (progress >= 1) {
            self.readingProgressView.fd_collapsed = YES;
            self.allReadingImage.hidden = NO;
        } else {
            self.readingProgressView.fd_collapsed = NO;
            self.allReadingImage.hidden = YES;
            [self.readingProgressLabel setText:[NSString stringWithFormat:@"阅读人数 %@/%@",@(announcement.reading),@(announcement.shouldReaderNumber)]];
            [self.readingProgress setProgress:0 animated:NO];
        }
    }
}
@end

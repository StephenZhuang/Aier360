//
//  ZXAnnouncementCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementCell.h"
#import "ZXTimeHelper.h"

@implementation ZXAnnouncementCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    _pointView.layer.cornerRadius = 5;
    _pointView.layer.masksToBounds = YES;
}

- (void)configureCellWithAnnouncement:(ZXAnnouncement *)announcement
{
    if (announcement.type == 1) {
        [_typeImage setImage:[UIImage imageNamed:@"ic_announcement_class"]];
    } else {
        [_typeImage setImage:[UIImage imageNamed:@"ic__announcement_school"]];
    }
    
    [self.titleLabel setText:announcement.title];
    [self.contentLabel setText:announcement.message];
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:announcement.ctime]];
    [self.pointView setHidden:announcement.isRead];
}
@end

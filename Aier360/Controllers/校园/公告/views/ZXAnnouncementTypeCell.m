//
//  ZXAnnouncementTypeCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementTypeCell.h"

@implementation ZXAnnouncementTypeCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.remarkImageView.hidden = NO;
    } else {
        self.remarkImageView.hidden = YES;
    }
}
@end

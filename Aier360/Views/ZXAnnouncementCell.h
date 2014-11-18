//
//  ZXAnnouncementCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"
#import "ZXAnnouncement.h"

@interface ZXAnnouncementCell : ZXBaseCell
@property (nonatomic , weak) IBOutlet UIImageView *typeImage;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet UIView *pointView;

- (void)configureCellWithAnnouncement:(ZXAnnouncement *)announcement;
@end

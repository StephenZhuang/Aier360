//
//  ZXAnnouncementCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXAnnouncement.h"

@interface ZXAnnouncementCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet UIImageView *allReadingImage;
@property (nonatomic , weak) IBOutlet UIView *readingProgressView;
@property (nonatomic , weak) IBOutlet UIProgressView *readingProgress;
@property (nonatomic , weak) IBOutlet UILabel *readingProgressLabel;

- (void)configureCellWithAnnouncement:(ZXAnnouncement *)announcement;
@end

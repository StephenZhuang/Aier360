//
//  ZXAnnouncementReceiverCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXAnnouncement.h"

@interface ZXAnnouncementReceiverCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , weak) IBOutlet UILabel *namesLabel;
- (void)configureWithAnnouncement:(ZXAnnouncement *)announcement isReceiver:(BOOL)isReceiver;
@end

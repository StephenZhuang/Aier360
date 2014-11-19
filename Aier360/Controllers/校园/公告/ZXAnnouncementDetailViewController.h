//
//  ZXAnnouncementDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXAnnouncement.h"

@interface ZXAnnouncementDetailViewController : ZXBaseViewController<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) ZXAnnouncement *announcement;
@property (nonatomic , weak) IBOutlet UILabel *typeLabel;
@property (nonatomic , weak) IBOutlet UILabel *senderLabel;
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet UIButton *readButton;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@end

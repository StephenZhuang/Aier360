//
//  ZXAnnouncementDetailViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXAnnouncement+ZXclient.h"

@interface ZXAnnouncementDetailViewController : ZXBaseViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) ZXAnnouncement *announcement;
@property (nonatomic , assign) long mid;
@property (nonatomic , copy) void (^deleteBlock)();
@end

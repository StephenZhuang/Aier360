//
//  ZXSendAnnouncementMessageViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/11.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXAnnounceMessage.h"

@interface ZXSendAnnouncementMessageViewController : ZXBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) ZXAnnounceMessage *announceMessage;
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , assign) NSInteger mesCount;
@end

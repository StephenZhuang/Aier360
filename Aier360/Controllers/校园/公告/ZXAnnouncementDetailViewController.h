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
@property (nonatomic , strong) ZXAnnouncement *announcement;

@end

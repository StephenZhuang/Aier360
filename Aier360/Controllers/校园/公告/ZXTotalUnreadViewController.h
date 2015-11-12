//
//  ZXTotalUnreadViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/11.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXAnnouncement.h"
#import "ZXAnnounceMessage.h"

@interface ZXTotalUnreadViewController : ZXBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *tablView;
@property (nonatomic , strong) ZXAnnouncement *announcement;

@property (nonatomic , weak) IBOutlet UILabel *unreadLabel;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) NSInteger teacherNum;
@end

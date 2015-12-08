//
//  ZXSchoolMenuViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXSchoolMenuViewController : ZXBaseViewController<EMChatManagerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL hasNewDynamic;
}
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) ZXIdentity identity;
@property (nonatomic , assign) BOOL hasReward;

@property (nonatomic , weak) IBOutlet UITableView *tableView;
@end

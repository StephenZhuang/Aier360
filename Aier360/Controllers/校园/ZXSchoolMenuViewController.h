//
//  ZXSchoolMenuViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXSchoolMenuViewController : ZXRefreshTableViewController<EMChatManagerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL hasNewDynamic;
    BOOL hasCache;
}
@property (nonatomic , assign) ZXIdentity identity;
@property (nonatomic , assign) BOOL hasReward;
@property (nonatomic , strong) NSMutableArray *itemArray;
@end

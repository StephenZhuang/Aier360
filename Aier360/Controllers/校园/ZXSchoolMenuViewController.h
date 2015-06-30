//
//  ZXSchoolMenuViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXSchoolMenuViewController : ZXBaseViewController<UITableViewDataSource ,UITableViewDelegate ,EMChatManagerDelegate,UIAlertViewDelegate>
{
    NSInteger unreadNum;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) ZXIdentity identity;
@property (nonatomic , weak) IBOutlet UIImageView *schoolImageView;
@property (nonatomic , weak) IBOutlet UIButton *imgNumButton;
@property (nonatomic , weak) IBOutlet UILabel *schoolNameLabel;
@end

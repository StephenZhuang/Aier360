//
//  ZXContactsViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXContactsViewController : ZXBaseViewController<UITableViewDataSource ,UITableViewDelegate>
@property (nonatomic , strong) NSArray *friendsArray;
@property (nonatomic , strong) NSMutableArray *sectionArray;
@property (nonatomic , strong) NSMutableArray *sectionTitleArray;
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@end

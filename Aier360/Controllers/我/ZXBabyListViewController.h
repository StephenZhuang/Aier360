//
//  ZXBabyListViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/30.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXBaby.h"

@interface ZXBabyListViewController : ZXBaseViewController<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) BOOL isMine;
@end

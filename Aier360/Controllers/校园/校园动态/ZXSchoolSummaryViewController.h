//
//  ZXSchoolSummaryViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/4.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXSchool+ZXclient.h"

@interface ZXSchoolSummaryViewController : ZXBaseViewController<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSArray *titleArray;
@property (nonatomic , strong) ZXSchoolDetail *schoolDetail;
@property (nonatomic , assign) BOOL editing;
@end

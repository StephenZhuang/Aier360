//
//  ZXReportViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXReportViewController : ZXBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSArray *typeArray;
@property (nonatomic , assign) long did;
@end

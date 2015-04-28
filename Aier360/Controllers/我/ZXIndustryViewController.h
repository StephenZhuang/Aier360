//
//  ZXIndustryViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/28.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXIndustryViewController : ZXBaseViewController<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSArray *industryArray;
@property (nonatomic , copy) void (^SelectIndustryBlock)(NSString *industry);
@end

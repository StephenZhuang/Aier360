//
//  ZXSettingsViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXSettingsViewController : ZXBaseViewController<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@end

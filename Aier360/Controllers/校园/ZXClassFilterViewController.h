//
//  ZXClassFilterViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/10.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXClassFilterViewController : ZXBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , copy) void (^selectClassBlock)();
@end

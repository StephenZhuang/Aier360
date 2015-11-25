//
//  ZXPayMessageOrderViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/23.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXMessageCommodity.h"

@interface ZXPayMessageOrderViewController : ZXBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , assign) NSInteger num;
@property (nonatomic , strong) ZXMessageCommodity *messageCommodity;
@property (nonatomic , weak) IBOutlet UITableView *tableView;

@end

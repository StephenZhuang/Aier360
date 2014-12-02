//
//  ZXDayViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXCardHistory+ZXclient.h"

@interface ZXDayHistoryViewController : ZXRefreshTableViewController
@property (nonatomic , strong) ZXCardHistory *history;
@property (nonatomic , assign) ZXIdentity identity;
@property (nonatomic , weak) IBOutlet UIView *tipView;
@end

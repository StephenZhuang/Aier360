//
//  ZXMessageTaskViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/14.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import <UICountingLabel/UICountingLabel.h>

@interface ZXMessageTaskViewController : ZXBaseViewController
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) NSInteger mesCount;

@property (nonatomic , weak) IBOutlet UICountingLabel *messageNumLabel;
@property (nonatomic , weak) IBOutlet UILabel *messageTipLabel;
@end

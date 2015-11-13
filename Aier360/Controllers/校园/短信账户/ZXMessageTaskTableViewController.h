//
//  ZXMessageTaskTableViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/13.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXBaseViewController.h"

@interface ZXMessageTaskTableViewController : UITableViewController
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) NSInteger mesCount;

@property (nonatomic , weak) IBOutlet UILabel *messageNumLabel;
@property (nonatomic , weak) IBOutlet UILabel *messageTipLabel;
+ (instancetype)viewControllerFromStoryboard;
@end

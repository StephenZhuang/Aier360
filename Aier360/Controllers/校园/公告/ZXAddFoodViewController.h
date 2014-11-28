//
//  ZXAddFoodViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/28.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXDailyFood+ZXclient.h"

@interface ZXAddFoodViewController : ZXBaseViewController<UITableViewDataSource ,UITableViewDelegate , UITextFieldDelegate>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , copy) NSString *date;
@property (nonatomic , weak) IBOutlet UIButton *smsButton;

@property (nonatomic , weak) IBOutlet UIView *pickView;
@property (nonatomic , weak) IBOutlet UIDatePicker *picker;
@property (nonatomic , strong) UIView *maskView;

@property (nonatomic , copy) void (^addSuccessBlock)();
@property (nonatomic , strong) ZXDailyFood *food;
@end

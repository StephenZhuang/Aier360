//
//  ZXTeacherPickViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXPosition+ZXclient.h"


@interface ZXTeacherPickViewController : ZXBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *submitButton;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , copy) NSString *tids;

@property (nonatomic , strong) NSMutableArray *selectedArray;
@property (nonatomic , strong) NSMutableArray *searchResults;

@property (nonatomic , copy) void (^selectBlock)(NSInteger selectedType,NSString *selectedTids,NSString *selectedTnams);
@end

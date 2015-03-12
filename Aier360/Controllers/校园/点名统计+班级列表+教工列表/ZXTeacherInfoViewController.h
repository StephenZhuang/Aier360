//
//  ZXTeacherInfoViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXTeacherNew.h"

@interface ZXTeacherInfoViewController : ZXBaseViewController<UITableViewDataSource ,UITableViewDelegate>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) ZXTeacherNew *teacher;
@property (nonatomic , weak) IBOutlet UIImageView *sexImageView;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
@end

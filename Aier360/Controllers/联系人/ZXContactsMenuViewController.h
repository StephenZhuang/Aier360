//
//  ZXContactsMenuViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXContactsMenuViewController : ZXBaseViewController<UITabBarDelegate ,UITableViewDataSource>
{
    NSArray *menuArray;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , assign) NSInteger num_grade;
@property (nonatomic , assign) NSInteger num_teacher;
@property (nonatomic , assign) NSInteger num_classes;
@property (nonatomic , assign) NSInteger num_student;
@end

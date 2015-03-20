//
//  ZXStudentInfoViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/18.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXStudent.h"

@interface ZXStudentInfoViewController : ZXRefreshTableViewController<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic , strong) ZXStudent *student;
@property (nonatomic , assign) long cid;
@end

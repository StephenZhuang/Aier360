//
//  ZXClassDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXClass.h"

@interface ZXClassDetailViewController : ZXRefreshTableViewController
@property (nonatomic , strong) ZXClass *zxclass;
@property (nonatomic , assign) NSInteger num_nologin_parent;
@property (nonatomic , weak) IBOutlet UILabel *unactiveLabel;
@end

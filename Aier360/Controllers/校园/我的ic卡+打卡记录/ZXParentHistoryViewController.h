//
//  ZXParentHistoryViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/3.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXDropTitleView.h"
#import "ZXStudent+ZXclient.h"

@interface ZXParentHistoryViewController : ZXRefreshTableViewController
@property (nonatomic , copy) NSString *dateString;
@property (nonatomic , strong) ZXStudent *currentStudent;
@end

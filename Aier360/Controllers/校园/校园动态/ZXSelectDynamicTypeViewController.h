//
//  ZXSelectDynamicTypeViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXClass+ZXclient.h"

@interface ZXSelectDynamicTypeViewController : ZXRefreshTableViewController
@property (nonatomic , copy) void (^selectTypeBlock)(ZXClass *selectedClass);
@end

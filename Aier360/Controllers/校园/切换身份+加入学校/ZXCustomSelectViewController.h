//
//  ZXCustomSelectViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXCustomSelectViewController : ZXRefreshTableViewController
@property (nonatomic , copy) void (^objectBlock)(id object);
@end

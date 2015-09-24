//
//  ZXWhoCanSeeViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXWhoCanSeeViewController : ZXRefreshTableViewController
@property (nonatomic , strong) NSArray *contents;
@property (nonatomic , strong) NSArray *imageNames;
@property (nonatomic , copy) void (^whocanseeBlock)(NSInteger index);
@end

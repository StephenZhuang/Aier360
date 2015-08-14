//
//  ZXAnnouncementTypeViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXAnnouncementTypeViewController : ZXRefreshTableViewController
@property (nonatomic , assign) NSInteger type;
@property (nonatomic , copy) NSString *tids;
@property (nonatomic , copy) void (^selectBlock)(NSInteger selectedType,NSString *selectedTids,NSString *selectedTnams);
@end

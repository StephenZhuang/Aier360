//
//  ZXAddBabyViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXAddBabyViewController : ZXRefreshTableViewController<UIActionSheetDelegate>
@property (nonatomic , strong) ZXUser *baby;
@property (nonatomic , copy) void (^addBlock)(ZXUser *baby);

@end

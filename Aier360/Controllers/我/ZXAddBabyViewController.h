//
//  ZXAddBabyViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXBaby+ZXclient.h"

@interface ZXAddBabyViewController : ZXRefreshTableViewController<UIActionSheetDelegate>
@property (nonatomic , strong) ZXBaby *baby;
@property (nonatomic , copy) void (^addBlock)(ZXBaby *baby);
@property (nonatomic , copy) void (^deleteBlock)();
@property (nonatomic , assign) BOOL isAdd;
@end

//
//  ZXAddFoodViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/28.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXDailyFood+ZXclient.h"

@interface ZXAddFoodViewController : ZXBaseViewController<UITableViewDataSource ,UITableViewDelegate , UITextFieldDelegate>

@property (nonatomic , copy) void (^addSuccessBlock)();
@property (nonatomic , strong) ZXDailyFood *food;
@end

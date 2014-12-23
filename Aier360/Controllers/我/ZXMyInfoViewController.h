//
//  ZXMyInfoViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXMyInfoViewController : ZXRefreshTableViewController<UIActionSheetDelegate ,UIPickerViewDelegate , UIPickerViewDataSource>
@property (nonatomic , strong) ZXUser *user;
@property (nonatomic , strong) NSArray *babyList;
@property (nonatomic , copy) void (^editSuccess)();

@end

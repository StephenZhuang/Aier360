//
//  ZXHomeworkDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXEmojiPicker.h"
#import "ZXHomework+ZXclient.h"

@interface ZXHomeworkDetailViewController : ZXRefreshTableViewController<UITextFieldDelegate>

@property (nonatomic , strong) ZXHomework *homework;
@property (nonatomic , assign) NSInteger hid;

@property (nonatomic , copy) void (^deleteBlock)();

@end

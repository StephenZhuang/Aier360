//
//  ZXDynamicDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXDynamic+ZXclient.h"
#import "ZXUser+ZXclient.h"
#import "ZXEmojiPicker.h"

@interface ZXDynamicDetailViewController : ZXRefreshTableViewController<UITextFieldDelegate>

@property (nonatomic , strong) ZXDynamic *dynamic;
@property (nonatomic , assign) NSInteger type;
@property (nonatomic , copy) void (^deleteBlock)();
@end

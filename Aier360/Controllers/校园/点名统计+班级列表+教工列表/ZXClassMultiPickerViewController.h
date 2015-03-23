//
//  ZXClassMultiPickerViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/17.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXClassMultiPickerViewController : ZXRefreshTableViewController
@property (nonatomic , copy) NSString *classids;
@property (nonatomic , copy) void (^ClassPickBlock)(NSString *classNames,NSString *classids);
@end

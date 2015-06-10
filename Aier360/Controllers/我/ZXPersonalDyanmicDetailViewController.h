//
//  ZXPersonalDyanmicDetailViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXPersonalDyanmicDetailViewController : ZXRefreshTableViewController
@property (nonatomic , assign) long did;
/**
 *  1:学校动态 2：个人动态
 */
@property (nonatomic , assign) NSInteger type;
@property (nonatomic , strong) NSMutableArray *prasedUserArray;
@end

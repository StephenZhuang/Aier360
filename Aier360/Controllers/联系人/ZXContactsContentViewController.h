//
//  ZXContactsContentViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 14/12/29.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXContactsContentViewController : ZXRefreshTableViewController
/**
 *  1:关注 2：互相关注 3：粉丝
 */
@property (nonatomic , assign) NSInteger type;
@end

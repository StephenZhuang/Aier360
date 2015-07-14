//
//  ZXSchollDynamicViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import <RKNotificationHub/RKNotificationHub.h>

@interface ZXSchollDynamicViewController : ZXRefreshTableViewController
{
    BOOL hasCache;
    RKNotificationHub *hub;
}
@property (nonatomic , assign) NSInteger unreadCount;
@end

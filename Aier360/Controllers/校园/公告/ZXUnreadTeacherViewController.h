//
//  ZXUnreadTeacherViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/12.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXAnnouncement.h"

@interface ZXUnreadTeacherViewController : ZXRefreshTableViewController
@property (nonatomic , strong) ZXAnnouncement *announcement;
@end

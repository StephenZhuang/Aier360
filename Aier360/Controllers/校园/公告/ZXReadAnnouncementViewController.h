//
//  ZXReadAnnouncementViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXReadHeader.h"

@interface ZXReadAnnouncementViewController : ZXRefreshTableViewController
@property (nonatomic , assign) NSInteger mid;
@property (nonatomic , strong) NSMutableArray *unreadDataArray;
@property (nonatomic , strong) ZXReadHeader *readHeader;
@property (nonatomic , strong) ZXReadHeader *unreadHeader;
@end

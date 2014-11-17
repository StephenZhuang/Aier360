//
//  ZXJoinTeacherViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXClass+ZXclient.h"
#import "ZXPosition+ZXclient.h"

@interface ZXJoinTeacherViewController : ZXRefreshTableViewController
@property (nonatomic , strong) ZXSchool *school;
@property (nonatomic , strong) NSArray *placeholderArray;
@property (nonatomic , strong) NSArray *titleArray;
@property (nonatomic , strong) NSMutableArray *classArray;
@property (nonatomic , strong) NSMutableArray *positionArray;
@property (nonatomic , strong) ZXClass *selectedClass;
@property (nonatomic , strong) ZXPosition *selectedPosition;
@end

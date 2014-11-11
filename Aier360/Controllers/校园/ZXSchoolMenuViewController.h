//
//  ZXSchoolMenuViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"


typedef NS_ENUM(NSUInteger, ZXIdentity) {
    ZXIdentitySchoolMaster = 1,
    ZXIdentityClassMaster = 2,
    ZXIdentityTeacher = 3,
    ZXIdentityParent = 4,
    ZXIdentityNone = 5,
    ZXIdentityStaff = 6
};
@interface ZXSchoolMenuViewController : ZXBaseViewController<UITableViewDataSource ,UITableViewDelegate>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) ZXIdentity identity;
@end

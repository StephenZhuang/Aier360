//
//  ZXSearchSchoolViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXSearchSchoolViewController : ZXRefreshTableViewController<UISearchBarDelegate>
@property (nonatomic , copy) NSString *cityid;
@end

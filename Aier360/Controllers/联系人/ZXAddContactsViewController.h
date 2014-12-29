//
//  ZXAddContactsViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 14/12/29.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXAddContactsViewController : ZXRefreshTableViewController<UISearchBarDelegate>
@property (nonatomic , weak) IBOutlet UISearchBar *searchBar;
@end

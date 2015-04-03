//
//  ZXAddContactsViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 14/12/29.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXAddContactsViewController : ZXBaseViewController<UISearchBarDelegate ,UISearchDisplayDelegate ,UITableViewDelegate ,UITableViewDataSource>
{
    BOOL hasMore;
    NSInteger pageCount;
    NSInteger page;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *searchResultArray;
@end

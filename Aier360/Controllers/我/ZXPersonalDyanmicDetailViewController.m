//
//  ZXPersonalDyanmicDetailViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDyanmicDetailViewController.h"
#import "ZXUser+ZXclient.h"

@implementation ZXPersonalDyanmicDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"详情";
}

- (void)loadData
{
    if (page == 0) {
        [ZXUser getPrasedUserWithDid:_did limitNumber:5 block:^(NSArray *array, NSInteger total, NSError *error) {
            [_prasedUserArray removeAllObjects];
            [_prasedUserArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }];
    }
}

#pragma -mark setters and getters
- (NSMutableArray *)prasedUserArray
{
    if (!_prasedUserArray) {
        _prasedUserArray = [[NSMutableArray alloc] init];
    }
    return _prasedUserArray;
}
@end

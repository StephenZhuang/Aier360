//
//  ZXRefreshTableViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

NSString *const MJTableViewCellIdentifier = @"Cell";

@implementation ZXRefreshTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    page = 1;
    pageCount = 10;
    hasMore = YES;
    self.dataArray = [[NSMutableArray alloc] init];
    [self addHeader];
    [self addFooter];
    [self.tableView setExtrueLineHidden];
}

- (void)addFooter
{
    [self.tableView addFooterWithCallback:^(void){
        page ++;
        [self loadData];
    }];
}

- (void)addHeader
{
    [self.tableView addHeaderWithCallback:^(void) {
        if (!hasMore) {
            [self.tableView setFooterHidden:NO];
        }
        page = 1;
        hasMore = YES;
        [self loadData];
    }];
    [self.tableView headerBeginRefreshing];
}

- (void)loadData
{
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    
    for (int i = 0; i < pageCount; i++) {
        int random = arc4random_uniform(1000000);
        [self.dataArray addObject:[NSString stringWithFormat:@"随机数据---%d", random]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        if (page == 1) {
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
            if (page == 5) {
                hasMore = NO;
                if (!hasMore) {
                    [self.tableView setFooterHidden:YES];
                }
            }
        }
    });
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier];
    
    if (indexPath.row < self.dataArray.count) {
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

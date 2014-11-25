//
//  ZXFoodListViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFoodListViewController.h"
#import "ZXDailyFood+ZXclient.h"
#import "ZXFoodTitleView.h"

@implementation ZXFoodListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"每日餐饮";
//    [self.tableView registerNib:[UINib nibWithNibName:@"ZXFoodTitleView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"titleView"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXDailyFood getFoodListWithSid:appStateInfo.sid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
        if (array) {
            if (page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            if (array.count < pageCount) {
                hasMore = NO;
                [self.tableView setFooterHidden:YES];
            }
        } else {
            hasMore = NO;
            [self.tableView setFooterHidden:YES];
        }
        if (page == 1) {
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZXDailyFood *food = self.dataArray[section];
    //TODO: 这里的分割方式有很大的问题，容易造成低级bug，已经提过，不改，以后出了问题可以甩锅
    //分割方法 餐点：食物\\n餐点：食物
    NSArray *arr = [food.content componentsSeparatedByString:@"\\n"];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZXFoodTitleView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"titleView"];
    if (view == nil) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"ZXFoodTitleView" owner:self options:nil] firstObject];
    }
    ZXDailyFood *food = self.dataArray[section];
    [view.timeButton setTitle:food.ddate forState:UIControlStateNormal];
    [view.editButton setHidden:food.state];
    [view.releasedImage setHidden:!food.state];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self configureTableView:tableView SchoolMasterCell:indexPath];
}

- (UITableViewCell *)configureTableView:(UITableView *)tableView SchoolMasterCell:(NSIndexPath *)indexPath
{
    ZXDailyFood *food = self.dataArray[indexPath.section];
    NSArray *arr = [food.content componentsSeparatedByString:@"\\n"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
    NSArray *array = [arr[indexPath.row] componentsSeparatedByString:@"："];
    [cell.textLabel setText:[array firstObject]];
    if (array.count > 1) {
        [cell.detailTextLabel setText:array[1]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 64; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
@end

//
//  ZXMyCardViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMyCardViewController.h"
#import "ZXICCard+ZXclient.h"
#import "ZXCardDetailViewController.h"

@interface ZXMyCardViewController ()

@end

@implementation ZXMyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的IC卡";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)loadData
{
    [ZXICCard getCardListWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (void)configureArray:(NSArray *)array
{
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:[NSString stringWithFormat:@"卡%i",indexPath.row+1]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZXICCard *card = self.dataArray[indexPath.row];
    ZXCardDetailViewController *vc = segue.destinationViewController;
    vc.card = card;
    vc.cardNum = cell.textLabel.text;
    __weak __typeof(&*self)weakSelf = self;
    vc.lossReportBlock = ^(void) {
        [weakSelf.tableView headerBeginRefreshing];
    };
}


@end

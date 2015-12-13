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
#import "ZXICCardTableViewCell.h"

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXICCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXICCardTableViewCell"];
    ZXICCard *card = [self.dataArray objectAtIndex:indexPath.section];
    [cell configureCellWithCard:card];
    cell.actionButton.tag = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)lostAction:(id)sender
{
    
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

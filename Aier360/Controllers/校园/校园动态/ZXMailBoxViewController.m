//
//  ZXMailBoxViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/8.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMailBoxViewController.h"
#import "ZXSchoolMasterEmail+ZXclient.h"
#import "ZXMailCell.h"

@implementation ZXMailBoxViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"校长信箱";
    
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXSchoolMasterEmail getEmailListWithSid:appStateInfo.sid block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (void)configureArray:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    if (array) {
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    [self.tableView headerEndRefreshing];
}

- (void)addFooter{}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ZXSchoolMasterEmail *email = self.dataArray[indexPath.section];
        return [ZXMailCell heightByText:email.content];
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ZXMailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMailCell"];
        ZXSchoolMasterEmail *email = self.dataArray[indexPath.section];
        [cell configureUIWithSchoolMasterEmail:email indexPath:indexPath];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.textLabel setText:@"回复"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)deleteAction:(UIButton *)sender
{
    
}
@end

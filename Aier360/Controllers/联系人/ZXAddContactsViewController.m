//
//  ZXAddContactsViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 14/12/29.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddContactsViewController.h"
#import "ZXUser+ZXclient.h"
#import "ZXContactsCell.h"
#import "ZXTimeHelper.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXUserDynamicViewController.h"

@implementation ZXAddContactsViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contacts" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXAddContactsViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加好友";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

//- (void)addHeader
//{
//    [self.tableView addHeaderWithCallback:^(void) {
//        if (!hasMore) {
//            [self.tableView setFooterHidden:NO];
//        }
//        page = 1;
//        hasMore = YES;
//        [self loadData];
//    }];
//}
//
//- (void)loadData
//{
//    NSString *string = _searchBar.text;
//    [ZXUser searchPeopleWithUid:GLOBAL_UID nickname:string page:page page_size:pageCount block:^(NSArray *array, NSError *error) {
//        [self configureArray:array];
//    }];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 65;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ZXUser *user = self.dataArray[indexPath.row];
//    ZXContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    [cell.titleLabel setText:user.nickname];
//    [cell.ageButton setTitle:[NSString stringWithIntger:[ZXTimeHelper ageFromBirthday:user.birthday]] forState:UIControlStateNormal];
//    if ([user.sex isEqualToString:@"男"]) {
//        [cell.ageButton setImage:[UIImage imageNamed:@"user_sex_male"] forState:UIControlStateNormal];
//        [cell.ageButton setBackgroundColor:[UIColor colorWithRed:113 green:169 blue:219]];
//    } else {
//        [cell.ageButton setImage:[UIImage imageNamed:@"user_sex_female"] forState:UIControlStateNormal];
//        [cell.ageButton setBackgroundColor:[UIColor colorWithRed:243 green:130 blue:198]];
//    }
//    [cell.addressLabel setText:user.address];
//    cell.focusButton.tag = indexPath.row;
//    if (user.state == 1) {
//        [cell.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
//        [cell.focusButton setEnabled:NO];
//    } else {
//        [cell.focusButton setTitle:@"关注" forState:UIControlStateNormal];
//        [cell.focusButton setEnabled:YES];
//    }
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ZXUser *user = self.dataArray[indexPath.row];
//    ZXUserDynamicViewController *vc = [ZXUserDynamicViewController viewControllerFromStoryboard];
//    vc.uid = user.uid;
//    [self.navigationController pushViewController:vc animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//    [self.tableView headerBeginRefreshing];
//}
//
//- (IBAction)focusAction:(UIButton *)sender
//{
//    ZXUser *user = self.dataArray[sender.tag];
//    user.state = 1;
//    __weak __typeof(&*self)weakSelf = self;
//    [ZXUser focusWithUid:GLOBAL_UID fuid:user.uid block:^(BOOL success, NSString *errorInfo) {
//        if (success) {
//            [MBProgressHUD showSuccess:@"" toView:self.view];
//        } else {
//            [MBProgressHUD showText:ZXFailedString toView:self.view];
//            user.state = 0;
//        }
//        [weakSelf.tableView reloadData];
//        
//    }];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    } else {
        return 52;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.titleLabel setText:[NSString stringWithFormat:@"我的爱儿号：%@",[ZXUtils sharedInstance].user.aier]];
        return cell;
    } else {
        ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXBaseCell"];
        if (indexPath.row == 0) {
            [cell.titleLabel setText:@"扫一扫"];
            [cell.logoImage setImage:[UIImage imageNamed:@"contact_scan"]];
        } else if (indexPath.row == 1) {
            [cell.titleLabel setText:@"添加微信好友"];
            [cell.logoImage setImage:[UIImage imageNamed:@"contact_weixin"]];
        } else {
            [cell.titleLabel setText:@"添加通讯录好友"];
            [cell.logoImage setImage:[UIImage imageNamed:@"contact_address"]];
        }
        return cell;
    }
}
@end

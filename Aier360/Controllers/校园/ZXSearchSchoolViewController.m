//
//  ZXSearchSchoolViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSearchSchoolViewController.h"
#import "ZXMenuCell.h"
#import "ZXSchool+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXSearchSchoolViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"搜索学校";
}

- (void)addHeader{}

- (void)addFooter{}

#pragma -mark search
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *schoolName = searchBar.text;
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"搜索中" toView:self.view];
    [ZXSchool searchSchoolWithCityid:_cityid schoolName:schoolName block:^(NSArray *array , NSError *error) {
        if (error) {
            [hud turnToError:@"搜索失败"];
        } else {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
//TODO
//            ZXAccount *account = [ZXUtils sharedInstance].account;
//            if (account.schoolList.count > 0) {
//                ZXSchool *school = [account.schoolList firstObject];
//                for (ZXSchool *zxschool in self.dataArray) {
//                    if (school.sid == zxschool.sid) {
//                        [self.dataArray removeObject:zxschool];
//                        break;
//                    }
//                }
//            }
            if (self.dataArray.count > 0) {
                [hud turnToSuccess:@"搜索成功"];
                [self.tableView reloadData];
            } else {
                [hud turnToText:@"暂无数据或者您已经加入过该学校"];
            }
        }
    }];
}

#pragma -mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXSchool *school = [self.dataArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:school.name];
    [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSchoolLogo:school.slogo]];
    return cell;
}
@end

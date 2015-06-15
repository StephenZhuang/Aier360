//
//  ZXCardHistoryMenuViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/28.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCardHistoryMenuViewController.h"

@interface ZXCardHistoryMenuViewController ()

@end

@implementation ZXCardHistoryMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"打卡记录";
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        [self.dataArray addObjectsFromArray:@[@"我的记录",@"教师记录",@"班级记录"]];
    } else if (HASIdentyty(ZXIdentityClassMaster)) {
        ZXAppStateInfo *appstateInfo = [[ZXUtils sharedInstance] getAppStateInfoWithIdentity:ZXIdentityClassMaster cid:0];
        [self.dataArray addObjectsFromArray:@[@"我的记录",[NSString stringWithFormat:@"%@的记录",appstateInfo.cname]]];
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)addHeader{}
- (void)addFooter{}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"my" sender:nil];
    } else if (indexPath.row == 1) {
        if (HASIdentyty(ZXIdentitySchoolMaster)) {
            [self performSegueWithIdentifier:@"teachers" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"myclass" sender:nil];
        }
    } else {
        [self performSegueWithIdentifier:@"class" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

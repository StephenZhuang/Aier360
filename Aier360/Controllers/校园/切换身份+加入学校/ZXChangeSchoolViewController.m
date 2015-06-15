//
//  ZXChangeSchoolViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXChangeSchoolViewController.h"
#import "ZXAccount+ZXclient.h"
#import "ZXMenuCell.h"

@interface ZXChangeSchoolViewController ()

@end

@implementation ZXChangeSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择学校";
    
    self.appStateInfoArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
}

- (void)addFooter
{
    
}

- (void)loadData
{
    [ZXAccount getSchoolWithUid:[NSString stringWithFormat:@"%li",[ZXUtils sharedInstance].user.uid] block:^(ZXAccount *account ,NSError *error) {
        if (!error) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:account.schoolList];
            [self.appStateInfoArray addObjectsFromArray:account.appStateInfolist];
            [self.tableView reloadData];
        }
        [self.tableView headerEndRefreshing];
    }];
}

#pragma mark- tableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXSchool *school = [self.dataArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:school.name];
    
    ZXSchool *mySchool = [ZXUtils sharedInstance].currentSchool;
    if (mySchool && (mySchool.sid == school.sid)) {
        [cell.itemImage setHidden:NO];
    } else {
        [cell.itemImage setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXSchool *school = [self.dataArray objectAtIndex:indexPath.row];
    [ZXUtils sharedInstance].currentSchool = school;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSuccess" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
}


@end

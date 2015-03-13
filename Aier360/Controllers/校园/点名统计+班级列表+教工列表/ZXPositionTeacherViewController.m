//
//  ZXPositionTeacherViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPositionTeacherViewController.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXUserDynamicViewController.h"
#import "ZXMyDynamicViewController.h"
#import "ZXMenuCell.h"
#import "ZXTeacherInfoViewController.h"
#import "ZXAddTeacherViewController.h"

@interface ZXPositionTeacherViewController ()

@end

@implementation ZXPositionTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _position.name;
    
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加教工" style:UIBarButtonItemStylePlain target:self action:@selector(addTeacher)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)addTeacher
{
    [self performSegueWithIdentifier:@"add" sender:nil];
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXTeacherNew getTeacherListWithSid:appStateInfo.sid gid:_position.gid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXTeacherNew *teacher = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell.titleLabel setText:teacher.tname];
    if (teacher.lastLogon) {
        [cell.hasNewLabel setText:@""];
        if ([teacher.sex isEqualToString:@"男"]) {
            [cell.logoImage setImage:[UIImage imageNamed:@"contact_male"]];
        } else {
            [cell.logoImage setImage:[UIImage imageNamed:@"contact_female"]];
        }
            
    } else {
        [cell.logoImage setImage:[UIImage imageNamed:@"contact_sexnone"]];
        [cell.hasNewLabel setText:@"还未登录过"];
    }
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
    if ([segue.identifier isEqualToString:@"detail"]) {        
        ZXMenuCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ZXTeacherNew *teacher = [self.dataArray objectAtIndex:indexPath.row];
        ZXTeacherInfoViewController *vc = [segue destinationViewController];
        vc.teacher = teacher;
    } else {
        ZXAddTeacherViewController *vc = segue.destinationViewController;
        vc.gid = _position.gid;
    }
}


@end

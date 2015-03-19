//
//  ZXContactsMenuViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXContactsMenuViewController.h"
#import "ZXMenuCell.h"
#import "ZXContactHeader.h"
#import "ZXTeachersViewController.h"
#import "ZXClassListViewController.h"
#import "ZXTeacherNew+ZXclient.h"

@interface ZXContactsMenuViewController ()

@end

@implementation ZXContactsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联系人";
    
    [self initTable];
    [self.tableView registerClass:[ZXContactHeader class] forHeaderFooterViewReuseIdentifier:@"contactHeader"];
    [self.tableView setExtrueLineHidden];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    
    [ZXTeacherNew getJobNumWithSid:[ZXUtils sharedInstance].currentAppStateInfo.sid block:^(NSInteger num_grade, NSInteger num_teacher, NSInteger num_classes, NSInteger num_student, NSError *error) {
        _num_grade = num_grade;
        _num_teacher = num_teacher;
        _num_classes = num_classes;
        _num_student = num_student;
        [self initTable];
    }];
    
}

- (void)initTable
{
    if (CURRENT_IDENTITY == ZXIdentityParent) {
        menuArray = @[@[@"好友"],@[@"班级列表"]];
    } else if (CURRENT_IDENTITY == ZXIdentityStaff) {
        menuArray = @[@[@"好友"],@[@"组织架构"]];
    } else {
        menuArray = @[@[@"好友"],@[@"组织架构",@"班级列表"]];
    }
    [self.tableView reloadData];
}

#pragma -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return menuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    } else {
        ZXContactHeader *contactHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"contactHeader"];
        [contactHeader.titleLabel setText:@"校园通讯录"];
        return contactHeader;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell.logoImage setImage:[UIImage imageNamed:menuArray[indexPath.section][indexPath.row]]];
    [cell.titleLabel setText:menuArray[indexPath.section][indexPath.row]];
    NSString *identfy = menuArray[indexPath.section][indexPath.row];
    if ([identfy isEqualToString:@"好友"]) {
        [cell.hasNewLabel setText:@""];
    } else if ([identfy isEqualToString:@"组织架构"]) {
        [cell.hasNewLabel setText:[NSString stringWithFormat:@"职务%i  |  教工%i",_num_grade,_num_teacher]];
    } else {
        if (CURRENT_IDENTITY == ZXIdentityParent) {
            [cell.hasNewLabel setText:[NSString stringWithFormat:@"班级%i  |  教工%i",_num_classes,_num_teacher]];
        } else {
            [cell.hasNewLabel setText:[NSString stringWithFormat:@"班级%i  |  学生%i",_num_classes,_num_student]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identfy = menuArray[indexPath.section][indexPath.row];
    if ([identfy isEqualToString:@"好友"]) {
        [self performSegueWithIdentifier:identfy sender:nil];
    } else if ([identfy isEqualToString:@"组织架构"]) {
        ZXTeachersViewController *vc = [ZXTeachersViewController viewControllerFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZXClassListViewController *vc = [ZXClassListViewController viewControllerFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
        
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

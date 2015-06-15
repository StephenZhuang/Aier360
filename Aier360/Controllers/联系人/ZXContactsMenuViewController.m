//
//  ZXContactsMenuViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXContactsMenuViewController.h"
#import "ZXMenuCell.h"
#import "ZXTeachersViewController.h"
#import "ZXClassListViewController.h"
#import "ZXTeacherNew+ZXclient.h"

@interface ZXContactsMenuViewController ()
{
    NSArray *menuArray;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , assign) NSInteger num_teacher;
@property (nonatomic , assign) NSInteger num_student;

@end

@implementation ZXContactsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联系人";
    
    [self initTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    
    [ZXTeacherNew getJobNumWithSid:[ZXUtils sharedInstance].currentSchool.sid appStates:[[ZXUtils sharedInstance] appStates] uid:GLOBAL_UID block:^(NSInteger num_teacher, NSInteger num_student, NSError *error) {
        _num_teacher = num_teacher;
        _num_student = num_student;
        [self initTable];
    }];
    
}

- (void)initTable
{
    ZXIdentity identity = [[ZXUtils sharedInstance] getHigherIdentity];
    if (identity == ZXIdentityParent) {
        menuArray = @[@[@"好友"],@[@"班级列表"]];
    } else if (identity == ZXIdentityStaff) {
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:170 green:176 blue:168]];
    
    header.contentView.backgroundColor = [UIColor colorWithRed:244 green:243 blue:238];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    } else {
        return @"校园通讯录";
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
        [cell.hasNewLabel setText:[NSString stringWithFormat:@"教工%i",_num_teacher]];
    } else {
        if ([[ZXUtils sharedInstance] getHigherIdentity] == ZXIdentityParent) {
            [cell.hasNewLabel setText:[NSString stringWithFormat:@"教工%i",_num_teacher]];
        } else {
            [cell.hasNewLabel setText:[NSString stringWithFormat:@"学生%i",_num_student]];
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

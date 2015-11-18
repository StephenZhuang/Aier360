//
//  ZXPositionTeacherViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPositionTeacherViewController.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXMenuCell.h"
#import "ZXTeacherInfoViewController.h"
#import "ZXAddTeacherViewController.h"

@interface ZXPositionTeacherViewController ()

@end

@implementation ZXPositionTeacherViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Teachers" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXPositionTeacherViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _position.name;
    
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加教师" style:UIBarButtonItemStylePlain target:self action:@selector(addTeacher)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)addTeacher
{
    ZXAddTeacherViewController *vc = [ZXAddTeacherViewController viewControllerFromStoryboard];
    vc.gid = _position.gid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData
{
    ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
    [ZXTeacherNew getTeacherListWithSid:school.sid gid:_position.gid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        
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
        [self configureBlankView];
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
    ZXTeacherNew *teacher = [self.dataArray objectAtIndex:indexPath.row];
    ZXTeacherInfoViewController *vc = [ZXTeacherInfoViewController viewControllerFromStoryboard];
    vc.teacher = teacher;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZXTeacherNew *teacher = [self.dataArray objectAtIndex:indexPath.row];
        [ZXTeacherNew deleteTeacherWithTid:teacher.tid block:^(BOOL success, NSString *errorInfo) {
        }];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters and setter
- (NSString *)blankString
{
    return @"该职务下还没添加教师！";
}

- (UIImage *)blankImage
{
    return [UIImage imageNamed:@"blank_teacher"];
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
    }
}


@end

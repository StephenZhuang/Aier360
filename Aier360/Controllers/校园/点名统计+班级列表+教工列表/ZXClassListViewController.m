//
//  ZXClassListViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClassListViewController.h"
#import "ZXClass+ZXclient.h"
#import "ZXClassDetailViewController.h"
#import "ZXMenuCell.h"
#import "ZXContactHeader.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXClassTeacherCell.h"
#import "ZXStudent.h"
#import "ZXTeacherInfoViewController.h"
#import "ZXStudentInfoViewController.h"

@interface ZXClassListViewController ()

@end

@implementation ZXClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"班级列表";
    searchTeacherResult = [[NSArray alloc] init];
    searchStudentResult = [[NSArray alloc] init];
    [self.tableView registerClass:[ZXContactHeader class] forHeaderFooterViewReuseIdentifier:@"contactHeader"];
}

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Teachers" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXClassListViewController"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)addFooter{}
- (void)setExtrueLineHidden{}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXClass getClassListWithSid:appStateInfo.sid uid:GLOBAL_UID appState:CURRENT_IDENTITY block:^(NSArray *array, NSError *error) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 30;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.dataArray.count;
    } else {
        if (section == 0) {
            return searchTeacherResult.count;
        } else {
            return searchStudentResult.count;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        ZXContactHeader *contactHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"contactHeader"];
        [contactHeader.titleLabel setText:@"班级"];
        return contactHeader;
    } else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {        
        ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMenuCell"];
        ZXClass *zxclass = [self.dataArray objectAtIndex:indexPath.row];
        [cell.titleLabel setText:zxclass.cname];
        if (CURRENT_IDENTITY == ZXIdentityParent) {
            [cell.hasNewLabel setText:[NSString stringWithFormat:@"教工%li",(long)zxclass.num_teacher]];
        } else {
            [cell.hasNewLabel setText:[NSString stringWithFormat:@"教工%li  |  学生%i",(long)zxclass.num_teacher,zxclass.num_student]];
        }
        return cell;
    } else {
        if (indexPath.section == 1) {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
            ZXStudent *student = [searchStudentResult objectAtIndex:indexPath.row];
            [cell.textLabel setText:student.sname];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"家长%i",student.num_parent]];
            return cell;
        } else {
            ZXClassTeacherCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXClassTeacherCell"];
            ZXTeacherNew *teacher = [searchTeacherResult objectAtIndex:indexPath.row];
            
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
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
    } else {
        if (indexPath.section == 0) {
            ZXTeacherInfoViewController *vc = [ZXTeacherInfoViewController viewControllerFromStoryboard];
            ZXTeacherNew *teacher = [searchTeacherResult objectAtIndex:indexPath.row];
            vc.teacher = teacher;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            ZXStudentInfoViewController *vc = [ZXStudentInfoViewController viewControllerFromStoryboard];
            ZXStudent *student = searchStudentResult[indexPath.row];
            vc.student = student;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchString.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"搜索中" toView:self.view];
        [ZXTeacherNew searchTeacherAndStudentListWithSid:[ZXUtils sharedInstance].currentAppStateInfo.sid name:searchString block:^(NSArray *teachers, NSArray *students, NSError *error) {
            [hud hide:YES];
            searchTeacherResult = teachers;
            searchStudentResult = students;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }];
    }
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
    ZXClass *zxclass = [self.dataArray objectAtIndex:indexPath.row];
    ZXClassDetailViewController *vc = segue.destinationViewController;
    vc.zxclass = zxclass;
}


@end

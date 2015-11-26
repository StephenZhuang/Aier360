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
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXClassTeacherCell.h"
#import "ZXStudent.h"
#import "ZXTeacherInfoViewController.h"
#import "ZXStudentInfoViewController.h"

@interface ZXClassListViewController ()
{
    NSArray *searchTeacherResult;
    NSArray *searchStudentResult;
}
@end

@implementation ZXClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[ZXUtils sharedInstance] getHigherIdentity] == ZXIdentityParent) {
        self.title = @"教师列表";
        self.searchDisplayController.searchBar.placeholder = @"输入教师姓名";
    } else {
        self.title = @"班级列表";
        self.searchDisplayController.searchBar.placeholder = @"输入学生或教师姓名";
    }
    searchTeacherResult = [[NSArray alloc] init];
    searchStudentResult = [[NSArray alloc] init];
    [self.searchDisplayController.searchResultsTableView setExtrueLineHidden];
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
    [ZXClass getClassListWithSid:[ZXUtils sharedInstance].currentSchool.sid uid:GLOBAL_UID appStates:[[ZXUtils sharedInstance] appStates] block:^(NSArray *array, NSError *error) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self configureBlankView];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return @"班级";
    } else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:HEADER_TITLE_COLOR];
    
    header.contentView.backgroundColor = HEADER_BG_COLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {        
        ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMenuCell"];
        ZXClass *zxclass = [self.dataArray objectAtIndex:indexPath.row];
        [cell.titleLabel setText:zxclass.cname];
        if ([[ZXUtils sharedInstance] getHigherIdentity] == ZXIdentityParent) {
            [cell.hasNewLabel setText:[NSString stringWithFormat:@"教师%li",(long)zxclass.num_teacher]];
        } else {
            [cell.hasNewLabel setText:[NSString stringWithFormat:@"教师%li  |  学生%i",(long)zxclass.num_teacher,zxclass.num_student]];
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
        
        NSString *cids = [self getCids];
        [ZXTeacherNew searchTeacherAndStudentListWithSid:[ZXUtils sharedInstance].currentSchool.sid name:searchString cids:cids appState:[[ZXUtils sharedInstance] getHigherIdentity] block:^(NSArray *teachers, NSArray *students, NSError *error) {
            [hud hide:YES];
            searchTeacherResult = teachers;
            searchStudentResult = students;
            [self.searchDisplayController.searchResultsTableView reloadData];
            
            if (teachers.count == 0 && students == 0) {
                for(UIView *subview in self.searchDisplayController.searchResultsTableView.subviews) {
                    
                    if([subview isKindOfClass:[UILabel class]]) {
                        
                        [(UILabel*)subview setText:@"啊哦，没有找到这个人！"];
                        
                    }
                    
                }
            }
        }];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    for(UIView *subview in self.searchDisplayController.searchResultsTableView.subviews) {
        
        if([subview isKindOfClass:[UILabel class]]) {
            
            [(UILabel*)subview setText:@""];
            
        }
        
    }
    return YES;
}

- (NSString *)getCids
{
    NSString *cids = @"";
    for (ZXClass *zxclass in self.dataArray) {
        cids = [cids stringByAppendingFormat:@"%li,",zxclass.cid];
    }
    if ([cids hasSuffix:@","]) {
        cids = [cids substringToIndex:cids.length - 1];
    }
    return cids;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters and setters
- (NSString *)blankString
{
    return @"老师还没有创建班级！";
}

- (UIImage *)blankImage
{
    return [UIImage imageNamed:@"blank_class"];
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

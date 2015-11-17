//
//  ZXTeachersViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeachersViewController.h"
#import "ZXPosition+ZXclient.h"
#import "ZXPositionTeacherViewController.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXMenuCell.h"
#import "ZXTeacherInfoViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXUnactiveTeacherViewController.h"

@interface ZXTeachersViewController ()
@property (nonatomic , strong) NSArray *searchResult;
@end

@implementation ZXTeachersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"教师列表";
    
    _searchResult = [[NSArray alloc] init];
    [self.searchDisplayController.searchResultsTableView setExtrueLineHidden];
}

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Teachers" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXTeachersViewController"];
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
    [ZXPosition getPositionListWithSid:[ZXUtils sharedInstance].currentSchool.sid block:^(NSArray *array, NSInteger num_nologin_teacher ,NSError *error) {
        self.num_nologin_teacher = num_nologin_teacher;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            if (HASIdentyty(ZXIdentitySchoolMaster)) {
                return 1;
            } else {
                return 0;
            }
        } else {
            return self.dataArray.count;
        }
    } else {
        return self.searchResult.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        return 45;
    } else {
        return 55;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return @"";
        } else {
            return @"职务";
        }
    } else {
        return @"搜索结果";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:HEADER_TITLE_COLOR];
    
    header.contentView.backgroundColor = HEADER_BG_COLOR;
    [header.textLabel setFont:[UIFont systemFontOfSize:13]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (indexPath.section == 0) {
            [cell.textLabel setText:@"未激活"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",@(self.num_nologin_teacher)]];
        } else {
            ZXPosition *position = [self.dataArray objectAtIndex:indexPath.row];
            [cell.textLabel setText:position.name];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@/%@",@(position.num_login_teacher),@(position.typeNumber)]];
        }
        return cell;
    } else {
        ZXMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXMenuCell"];
        ZXTeacherNew *teacher = [self.searchResult objectAtIndex:indexPath.row];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            ZXUnactiveTeacherViewController *vc = [ZXUnactiveTeacherViewController viewControllerFromStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            ZXPosition *position = [self.dataArray objectAtIndex:indexPath.row];
            ZXPositionTeacherViewController *vc = [ZXPositionTeacherViewController viewControllerFromStoryboard];
            vc.position = position;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        ZXTeacherInfoViewController *vc = [ZXTeacherInfoViewController viewControllerFromStoryboard];
        ZXTeacherNew *teacher = [self.searchResult objectAtIndex:indexPath.row];
        vc.teacher = teacher;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchString.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"搜索中" toView:self.view];
        [ZXTeacherNew searchTeacherWithSid:[ZXUtils sharedInstance].currentSchool.sid tname:searchString block:^(NSArray *array, NSError *error) {
            [hud hide:YES];
            _searchResult = array;
            [self.searchDisplayController.searchResultsTableView reloadData];
            
            if (array.count == 0) {
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

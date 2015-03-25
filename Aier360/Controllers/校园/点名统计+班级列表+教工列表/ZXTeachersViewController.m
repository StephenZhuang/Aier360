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
#import "ZXContactHeader.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXMenuCell.h"
#import "ZXTeacherInfoViewController.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXTeachersViewController ()
@property (nonatomic , strong) NSArray *searchResult;
@end

@implementation ZXTeachersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"组织架构";
    [self.tableView registerClass:[ZXContactHeader class] forHeaderFooterViewReuseIdentifier:@"contactHeader"];
    
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
    [ZXPosition getPositionListWithSid:[ZXUtils sharedInstance].currentAppStateInfo.sid block:^(NSArray *array ,NSError *error) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.dataArray.count;
    } else {
        return _searchResult.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZXContactHeader *contactHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"contactHeader"];
    if (tableView == self.tableView) {
        [contactHeader.titleLabel setText:@"职务"];
    } else {
        [contactHeader.titleLabel setText:@"搜索结果"];
    }
    return contactHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        ZXPosition *position = [self.dataArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:position.name];
        [cell.detailTextLabel setText:[NSString stringWithIntger:position.typeNumber]];
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
        [ZXTeacherNew searchTeacherWithSid:[ZXUtils sharedInstance].currentAppStateInfo.sid tname:searchString block:^(NSArray *array, NSError *error) {
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
    if ([segue.identifier isEqualToString:@"positionTeacher"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ZXPosition *position = [self.dataArray objectAtIndex:indexPath.row];
        ZXPositionTeacherViewController *vc = segue.destinationViewController;
        vc.position = position;
    }
}


@end

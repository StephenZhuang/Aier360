//
//  ZXTeacherPickViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTeacherPickViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXTeacherPickCell.h"
#import "ZXTeacherNew.h"
#import "ZXTagsTableViewCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

@interface ZXTeacherPickViewController ()

@end

@implementation ZXTeacherPickViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXTeacherPickViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择教工";
    [self.tableView setExtrueLineHidden];

    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"加载中..." toView:self.view];
    [ZXPosition getPositionListWithSid:[ZXUtils sharedInstance].currentSchool.sid tids:_tids block:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [hud hide:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                for (ZXPosition *position in self.dataArray) {
                    for (ZXTeacherNew *teacher in position.list) {
                        if (teacher.isSelected) {
                            [self.selectedArray addObject:teacher];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            });
        } else {
            [hud turnToError:error.localizedDescription];
        }
    }];
    
    NSInteger num = 0;
    if (_tids) {
        num = [[_tids componentsSeparatedByString:@","] count];
    }
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:[NSString stringWithFormat:@"确定(%@)",@(num)] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setFrame:CGRectMake(0, 0, 100, 30)];
    submitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitleColor: [UIColor colorWithRed:133/255.0 green:216/255.0 blue:188/255.0 alpha:1.0] forState:UIControlStateDisabled];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = item;
    if (num == 0) {
        submitButton.enabled = NO;
    } else {
        submitButton.enabled = YES;
    }
    
    self.searchDisplayController.searchResultsTableView.allowsMultipleSelection = YES;
    [self.searchDisplayController.searchResultsTableView setExtrueLineHidden];
}

- (void)submit
{
    NSMutableArray *tidArray = [[NSMutableArray alloc] init];
    NSMutableArray *tnameArray = [[NSMutableArray alloc] init];
    for (ZXTeacherNew *teacher in self.selectedArray) {
        [tidArray addObject:[NSString stringWithFormat:@"%@",@(teacher.tid)]];
        [tnameArray addObject:teacher.tname];
    }
    NSString *selectedTids = [tidArray componentsJoinedByString:@","];
    NSString *selectedTnames = [tnameArray componentsJoinedByString:@","];
    !_selectBlock?:_selectBlock(3,selectedTids,selectedTnames);
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
}

- (void)configureSubmitButton
{
    NSInteger num = self.selectedArray.count;
    [submitButton setTitle:[NSString stringWithFormat:@"确定(%@)",@(num)] forState:UIControlStateNormal];
    if (num == 0) {
        submitButton.enabled = NO;
    } else {
        submitButton.enabled = YES;
    }
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return self.dataArray.count + 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            if (self.selectedArray.count > 0) {
                return 1;
            } else {
                return 0;
            }
        } else {
            ZXPosition *position = self.dataArray[section - 1];
            return position.list.count;
        }
    } else {
        return self.searchResults.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            ZXTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXTagsTableViewCell"];
            cell.selectedArray = self.selectedArray;
            return [cell getHeight];
        } else {
            return 50;
        }
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            __weak __typeof(&*self)weakSelf = self;
            ZXTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXTagsTableViewCell"];
            [cell setSelectedArray:self.selectedArray];
            cell.clickBlock = ^(NSInteger index) {
                ZXTeacherNew *teacher = weakSelf.selectedArray[index];
                teacher.isSelected = NO;
                [weakSelf.selectedArray removeObject:teacher];
                [weakSelf configureSubmitButton];
                [weakSelf.tableView reloadData];
                
            };
            return cell;
        } else {
            ZXTeacherPickCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXTeacherPickCell"];
            ZXPosition *position = self.dataArray[indexPath.section - 1];
            ZXTeacherNew *teacher = position.list[indexPath.row];
            [cell.nameLabel setText:teacher.tname];
            if (teacher.isSelected) {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            } else {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            if (teacher.lastLogon) {
                if ([teacher.sex isEqualToString:@"男"]) {
                    [cell.headImage setImage:[UIImage imageNamed:@"contact_male"]];
                } else {
                    [cell.headImage setImage:[UIImage imageNamed:@"contact_female"]];
                }
            } else {
                [cell.headImage setImage:[UIImage imageNamed:@"contact_sexnone"]];
            }
            return cell;
        }
    } else {
        ZXTeacherPickCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXTeacherPickCell"];
        ZXTeacherNew *teacher = self.searchResults[indexPath.row];
        [cell.nameLabel setText:teacher.tname];
        if (teacher.isSelected) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        } else {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        if (teacher.lastLogon) {
            if ([teacher.sex isEqualToString:@"男"]) {
                [cell.headImage setImage:[UIImage imageNamed:@"contact_male"]];
            } else {
                [cell.headImage setImage:[UIImage imageNamed:@"contact_female"]];
            }
        } else {
            [cell.headImage setImage:[UIImage imageNamed:@"contact_sexnone"]];
        }
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return nil;
        } else {
            ZXPosition *position = self.dataArray[section - 1];
            return [NSString stringWithFormat:@"%@(%@)",position.name,@(position.list.count)];
        }
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return 0.01;
        } else {
            return 20;
        }
    } else {
        return 0.01;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor: [UIColor colorWithRed:179/255.0 green:176/255.0 blue:168/255.0 alpha:1.0]];
    [header.textLabel setFont:[UIFont systemFontOfSize:13]];
    
    header.contentView.backgroundColor = [UIColor colorWithRed:247 green:245 blue:237];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section > 0) {
            ZXPosition *position = self.dataArray[indexPath.section - 1];
            ZXTeacherNew *teacher = position.list[indexPath.row];
            teacher.isSelected = YES;
            [self.selectedArray addObject:teacher];
            [self configureSubmitButton];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else {
        ZXTeacherNew *teacher = self.searchResults[indexPath.row];
        teacher.isSelected = YES;
        [self.selectedArray addObject:teacher];
        [self configureSubmitButton];
        [self.tableView reloadData];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section > 0) {
            ZXPosition *position = self.dataArray[indexPath.section - 1];
            ZXTeacherNew *teacher = position.list[indexPath.row];
            teacher.isSelected = NO;
            
            [self.selectedArray removeObject:teacher];
            [self configureSubmitButton];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else {
        ZXTeacherNew *teacher = self.searchResults[indexPath.row];
        teacher.isSelected = NO;
        
        [self.selectedArray removeObject:teacher];
        [self configureSubmitButton];
        [self.tableView reloadData];
    }
}

#pragma mark - searchbar delegate
#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (ZXPosition *position in self.dataArray) {
            for (ZXTeacher *teacher in position.list) {
                if ([teacher.tname rangeOfString:searchText].location != NSNotFound ) {
                    
                    [results addObject:teacher];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchResults removeAllObjects];
            [self.searchResults addObjectsFromArray:results];
            [self.searchDisplayController.searchResultsTableView reloadData];
        });
    });
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - setters and getters
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}

- (NSMutableArray *)searchResults
{
    if (!_searchResults) {
        _searchResults = [[NSMutableArray alloc] init];
    }
    return _searchResults;
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

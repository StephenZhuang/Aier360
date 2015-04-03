//
//  ZXContactsViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXContactsViewController.h"
#import "TopBarView.h"
#import "ZXAddContactsViewController.h"
#import "ZXFriend+ZXclient.h"
#import "ZXContactsCell.h"
#import "ZXTimeHelper.h"
#import "ZXUserDynamicViewController.h"
#import "ZXMyDynamicViewController.h"

#define INDEX_ARRAY (@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"])

@interface ZXContactsViewController ()
{
    NSInteger requestNum;
}
@property (nonatomic , strong) NSArray *friendsArray;
@property (nonatomic , strong) NSMutableArray *sectionArray;
@property (nonatomic , strong) NSMutableArray *sectionTitleArray;
@property (nonatomic , strong) NSMutableArray *searchResult;
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@end

@implementation ZXContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"好友";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addContacts)];
    self.navigationItem.rightBarButtonItem = item;
    
    [_tableView setSectionIndexColor:[UIColor colorWithRed:95 green:95 blue:95]];
    [_tableView setSectionIndexBackgroundColor:[UIColor colorWithRed:255 green:252 blue:248]];
    [_tableView setExtrueLineHidden];
    [self.searchDisplayController.searchResultsTableView setExtrueLineHidden];
    
    requestNum = 0;
    [ZXFriend getFriendRequestNumWithUid:GLOBAL_UID block:^(NSInteger num_requestFriends, NSError *error) {
        requestNum = num_requestFriends;
        [self.tableView reloadData];
    }];
    
    _searchResult = [[NSMutableArray alloc] init];
    [self initData];
    [self loadData];
}

- (void)loadData
{
    [ZXFriend getFriendListWithUid:GLOBAL_UID block:^(NSArray *array, NSError *error) {
        [self initData];
    }];
}

- (void)initData
{
    _sectionArray = nil;
    _sectionTitleArray = nil;
    _friendsArray = nil;
    _sectionTitleArray = [[NSMutableArray alloc] initWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"]];
    _sectionArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < INDEX_ARRAY.count; i++) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [_sectionArray addObject:arr];
    }
    

    _friendsArray = [ZXFriend where:@"uid == %@",@(GLOBAL_UID)];

    [self setupFriends];
    [self.tableView reloadData];
}

- (void)setupFriends
{
    for (ZXFriend *friend in _friendsArray) {
        NSInteger index = [INDEX_ARRAY indexOfObject:friend.firstLetter];
        if (index == NSNotFound) {
            [[_sectionArray lastObject] addObject:friend];
        } else {
            [[_sectionArray objectAtIndex:index] addObject:friend];
        }
        
    }
    
    for (int i = _sectionArray.count - 1; i >= 0; i--) {
        if (i < _sectionArray.count) {
            
            NSMutableArray *arr = _sectionArray[i];
            if (arr.count == 0) {
                [_sectionTitleArray removeObjectAtIndex:i];
                [_sectionArray removeObjectAtIndex:i];
            } else if (arr.count > 1) {
                NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
                NSWidthInsensitiveSearch|NSForcedOrderingSearch;
                NSComparator sort = ^(ZXFriend *obj1,ZXFriend *obj2){
                    
                    return [obj1.pinyin compare:obj2.pinyin options:comparisonOptions];
                };
                NSArray *resultArray = [arr sortedArrayUsingComparator:sort];
                [_sectionArray replaceObjectAtIndex:i withObject:[resultArray mutableCopy]];
            } else {
            }
        }
    }
}

- (void)addContacts
{
    [self performSegueWithIdentifier:@"add" sender:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

#pragma -mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        if (_friendsArray.count > 0) {
            return _sectionTitleArray.count + 1;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return 1;
        } else {
            NSMutableArray *arr = _sectionArray[section - 1];
            return [arr count];
        }
    } else {
        return _searchResult.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return _sectionTitleArray;
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.tableView) {
        return index+1;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    }
    return _sectionTitleArray[section - 1];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:170 green:176 blue:168]];
    
    header.contentView.backgroundColor = [UIColor colorWithRed:244 green:243 blue:238];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            ZXContactsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (requestNum == 0) {
                [cell.addressLabel setHidden:YES];
            } else {
                [cell.addressLabel setHidden:NO];
                [cell.addressLabel setText:[NSString stringWithFormat:@"%@",@(requestNum)]];
            }
            return cell;
        } else {
            
            ZXContactsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXContactsCell"];
            ZXFriend *friend = [self.sectionArray[indexPath.section - 1] objectAtIndex:indexPath.row];
            [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:friend.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            [cell.titleLabel setText:[friend displayName]];
            NSArray *birthArray = [friend.babyBirthdays componentsSeparatedByString:@","];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSString *birth in birthArray) {
                NSString *babyStr = [NSString stringWithFormat:@"宝宝%@",[ZXTimeHelper yearAndMonthSinceNow:birth]];
                [arr addObject:babyStr];
            }
            NSString *str = [arr componentsJoinedByString:@"&"];
            [cell.addressLabel setText:str];
            
            return cell;
        }
    } else {
        ZXContactsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXContactsCell"];
        ZXFriend *friend = [self.searchResult objectAtIndex:indexPath.row];
        [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:friend.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [cell.titleLabel setText:[friend displayName]];
        NSArray *birthArray = [friend.babyBirthdays componentsSeparatedByString:@","];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSString *birth in birthArray) {
            NSString *babyStr = [NSString stringWithFormat:@"宝宝%@",[ZXTimeHelper yearAndMonthSinceNow:birth]];
            [arr addObject:babyStr];
        }
        NSString *str = [arr componentsJoinedByString:@"&"];
        [cell.addressLabel setText:str];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            
        } else {
            ZXFriend *user = [self.sectionArray[indexPath.section-1] objectAtIndex:indexPath.row];
            if (user.fuid == GLOBAL_UID) {
                ZXMyDynamicViewController *vc = [ZXMyDynamicViewController viewControllerFromStoryboard];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                ZXUserDynamicViewController *vc = [ZXUserDynamicViewController viewControllerFromStoryboard];
                vc.uid = user.fuid;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else {
        ZXFriend *user = [self.searchResult objectAtIndex:indexPath.row];
        if (user.fuid == GLOBAL_UID) {
            ZXMyDynamicViewController *vc = [ZXMyDynamicViewController viewControllerFromStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            ZXUserDynamicViewController *vc = [ZXUserDynamicViewController viewControllerFromStoryboard];
            vc.uid = user.fuid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
        for (ZXFriend *friend in _friendsArray) {
            if ([friend.account rangeOfString:searchText].location != NSNotFound || [[friend displayName] rangeOfString:searchText].location != NSNotFound || (friend.aier.length > 0 && [friend.aier rangeOfString:searchText].location != NSNotFound) || [[friend.pinyin stringByReplacingOccurrencesOfString:@" " withString:@""] rangeOfString:[searchText uppercaseString]].location != NSNotFound) {
                
                [results addObject:friend];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchResult removeAllObjects];
            [self.searchResult addObjectsFromArray:results];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newFriend"]) {
        requestNum = 0;
        [self.tableView reloadData];
    }
}
@end

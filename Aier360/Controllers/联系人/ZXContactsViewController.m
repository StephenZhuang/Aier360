//
//  ZXContactsViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXContactsViewController.h"
#import "TopBarView.h"
#import "ZXContactsContentViewController.h"
#import "ZXAddContactsViewController.h"
#import "ZXFriend+ZXclient.h"
#import "ZXContactsCell.h"
#import "ZXTimeHelper.h"

#define INDEX_ARRAY (@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"])

@interface ZXContactsViewController ()
@end

@implementation ZXContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"好友";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain target:self action:@selector(addContacts)];
    self.navigationItem.rightBarButtonItem = item;
    
    [_tableView setSectionIndexColor:[UIColor colorWithRed:95 green:95 blue:95]];
    [_tableView setExtrueLineHidden];
    
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
    

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 耗时的操作
        _friendsArray = [ZXFriend where:@"uid == %@",@(GLOBAL_UID)];
        
        [self setupFriends];
//        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.tableView reloadData];
//        });
//    });
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
    if (_friendsArray.count > 0) {
        return _sectionTitleArray.count + 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        NSMutableArray *arr = _sectionArray[section - 1];
        return [arr count];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sectionTitleArray;
//    return INDEX_ARRAY;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index+1;
//    __block NSInteger scrollIndex;
//    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, index+1)];
//    [INDEX_ARRAY enumerateObjectsAtIndexes:indexSet options:NSEnumerationReverse usingBlock:^(NSString *letter, NSUInteger index, BOOL *stop) {
//        scrollIndex = [_sectionTitleArray indexOfObject:letter] + 1;
//        *stop = scrollIndex != NSNotFound;
//    }];
//    NSLog(@"%@ ， %@",title,[_sectionTitleArray objectAtIndex:scrollIndex]);
//    return scrollIndex;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //    NSArray *arr = @[@"★ 星标朋友",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    if (section == 0) {
        return @"";
    }
    return _sectionTitleArray[section - 1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXContactsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXContactsCell"];
        return cell;
    } else {
        
        ZXContactsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ZXContactsCell"];
        ZXFriend *friend = [self.sectionArray[indexPath.section - 1] objectAtIndex:indexPath.row];
        [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:friend.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [cell.titleLabel setText:friend.nickname];
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
//    MFriend *friend = _sectionArray[indexPath.section][indexPath.row];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dating" bundle:nil];
//    OtherPersonViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"OtherPersonViewController"];
//    vc.userid = friend.id;
//    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

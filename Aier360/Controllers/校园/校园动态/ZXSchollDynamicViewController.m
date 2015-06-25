//
//  ZXSchollDynamicViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchollDynamicViewController.h"
#import "ZXPersonalDynamic+ZXclient.h"
#import "NSManagedObject+ZXRecord.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "ZXSchoolDynamicCell.h"
#import "ZXPersonalDyanmicDetailViewController.h"
#import "ZXReleaseSchoolDynamicViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXPopMenu.h"
#import "ZXSchoolMessageListViewController.h"
#import "ZXCommentViewController.h"

@implementation ZXSchollDynamicViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSchollDynamicViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"校园动态";
    
    hasCache = YES;
    
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    if (HASIdentyty(ZXIdentitySchoolMaster) || HASIdentyty(ZXIdentityClassMaster) || HASIdentyty(ZXIdentityStaff || HASIdentyty(ZXIdentityTeacher))) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_release"] style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
        [itemArray addObject:item];
    }
    
    UIBarButtonItem *menssageItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_comment_n"] style:UIBarButtonItemStylePlain target:self action:@selector(messageList)];
    [itemArray addObject:menssageItem];
    self.navigationItem.rightBarButtonItems = itemArray;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSArray *arrary = [ZXPersonalDynamic where:@{@"sid":@([ZXUtils sharedInstance].currentSchool.sid)} order:@{@"cdate" : @"DESC"} limit:@(pageCount)];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.dataArray addObjectsFromArray:arrary];
            [self.tableView reloadData];
            if (arrary.count < pageCount) {
                hasCache = NO;
            }
        });
    });
}

- (IBAction)addAction:(id)sender
{
    ZXReleaseSchoolDynamicViewController *vc = [ZXReleaseSchoolDynamicViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)messageList
{
    ZXSchoolMessageListViewController *vc = [ZXSchoolMessageListViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)addFooter
{
    [self.tableView addFooterWithCallback:^(void){
        page++;
        if (hasCache) {
            [self loadCaChe];
        } else {
            [self loadMore];
        }
    }];
}

- (void)addHeader
{
    [self.tableView addHeaderWithCallback:^(void) {
        page = 1;
        [self.tableView setFooterHidden:NO];
        
        [self loadData];
    }];
    [self.tableView headerBeginRefreshing];
}

- (void)loadData
{
    NSString *time = @"";
    if (self.dataArray.count > 0) {
        ZXPersonalDynamic *dynamic = [self.dataArray lastObject];
        time = dynamic.cdate;
    }
    [ZXPersonalDynamic getLatestSchoolDynamicWithUid:GLOBAL_UID time:time pageSize:pageCount sid:[ZXUtils sharedInstance].currentSchool.sid block:^(NSArray *array, NSError *error) {
//        [self.dataArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
//        [self.tableView reloadData];
//        [self.dataArray removeAllObjects];
        hasCache = YES;
        [self loadCaChe];
        [self.tableView headerEndRefreshing];
    }];
}

- (void)loadMore
{
    NSString *time = @"";
    if (self.dataArray.count > 0) {
        ZXPersonalDynamic *dynamic = [self.dataArray lastObject];
        time = dynamic.cdate;
    }
    
    [ZXPersonalDynamic getOlderSchoolDynamicWithUid:GLOBAL_UID time:time pageSize:pageCount sid:[ZXUtils sharedInstance].currentSchool.sid block:^(NSArray *array, NSError *error) {
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
        if (array.count < pageCount) {
            hasMore = NO;
            [self.tableView setFooterHidden:YES];
        }
    }];
}

- (void)loadCaChe
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *time = @"";
        if (self.dataArray.count > 0) {
            ZXPersonalDynamic *dynamic = [self.dataArray lastObject];
            time = dynamic.cdate;
        }
        NSPredicate *predicate;
        if (page == 1) {
            predicate = [NSPredicate predicateWithFormat:@"(sid == %@)",@([ZXUtils sharedInstance].currentSchool.sid)];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"(sid == %@) AND (cdate < %@)",@([ZXUtils sharedInstance].currentSchool.sid), time];
        }
        NSArray *array = [ZXPersonalDynamic where:predicate order:@{@"cdate" : @"DESC"} limit:@(pageCount)];
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
            
            if (array.count < pageCount) {
                hasCache = NO;
            }
        });
    });
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
    return [tableView fd_heightForCellWithIdentifier:@"ZXSchoolDynamicCell" cacheByIndexPath:indexPath configuration:^(ZXSchoolDynamicCell *cell) {
        [cell configureWithDynamic:dynamic];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
    ZXSchoolDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXSchoolDynamicCell"];
    [cell configureWithDynamic:dynamic];
    cell.favButton.tag = indexPath.section;
    cell.commentButton.tag = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:indexPath.section];
    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
    vc.did = dynamc.did;
    vc.type = 1;
    vc.dynamic = dynamc;
    vc.isCachedDynamic = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)favAction:(UIButton *)sender
{
    if (sender.selected) {
        [MBProgressHUD showText:@"不能取消赞" toView:self.view];
    } else {
        ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:sender.tag];
        dynamc.hasParise = 1;
        dynamc.pcount++;
        [dynamc save];
        sender.selected = YES;
        [sender setTitle:[NSString stringWithFormat:@"%@",@(dynamc.pcount)] forState:UIControlStateNormal];
        [sender setTitle:[NSString stringWithFormat:@"%@",@(dynamc.pcount)] forState:UIControlStateSelected];
        [ZXPersonalDynamic praiseDynamicWithUid:GLOBAL_UID did:dynamc.did type:1 block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                dynamc.hasParise = 0;
                dynamc.pcount = MAX(0, dynamc.pcount-1);
                [dynamc save];
                sender.selected = NO;;
                [sender setTitle:[NSString stringWithFormat:@"%@",@(dynamc.pcount)] forState:UIControlStateNormal];
                [sender setTitle:[NSString stringWithFormat:@"%@",@(dynamc.pcount)] forState:UIControlStateSelected];
                [MBProgressHUD showText:errorInfo toView:self.view];
            }
        }];
    }
}

- (IBAction)commentAction:(UIButton *)sender
{
    ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:sender.tag];
    ZXCommentViewController *vc = [ZXCommentViewController viewControllerFromStoryboard];
    vc.type = dynamc.type;
    vc.did = dynamc.did;
    vc.commentBlock = ^(void) {
        dynamc.ccount++;
        [dynamc save];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:sender.tag]] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
}
@end

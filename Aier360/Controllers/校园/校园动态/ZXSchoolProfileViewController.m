//
//  ZXSchoolProfileViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/14.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolProfileViewController.h"
#import "ZXChangeSchoolViewController.h"
#import "ZXPersonalDynamic+ZXclient.h"
#import "ZXSchoolDynamicCell.h"
#import "ZXManagedUser.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "UIViewController+ZXPhotoBrowser.h"
#import "ZXMyProfileViewController.h"
#import "ZXUserProfileViewController.h"
#import "ZXSquareDynamicsViewController.h"
#import "ZXPersonalDyanmicDetailViewController.h"
#import "NSManagedObject+ZXRecord.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXSchoolProfileViewController ()

@end

@implementation ZXSchoolProfileViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"切换学校" style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    self.navigationItem.rightBarButtonItem = item;
    self.title = @"校园主页";
    [self loadFirstCache];
}

- (IBAction)moreAction:(id)sender
{
    ZXChangeSchoolViewController *vc = [ZXChangeSchoolViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
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
    __weak __typeof(&*self)weakSelf = self;
    ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
    ZXSchoolDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXSchoolDynamicCell"];
    [cell configureWithDynamic:dynamic];
    cell.imageClickBlock = ^(NSInteger index) {
        NSArray *array = [dynamic.img componentsSeparatedByString:@","];
        [weakSelf browseImage:array index:index];
    };
    cell.headClickBlock = ^(void) {
        ZXManagedUser *user = dynamic.user;
        if (user.uid == GLOBAL_UID) {
            ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
            vc.uid = user.uid;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    cell.squareLabelBlock = ^(NSInteger oslid) {
        ZXSquareDynamicsViewController *vc = [ZXSquareDynamicsViewController viewControllerFromStoryboard];
        vc.oslid = oslid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
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
        [MBProgressHUD showText:@"您已经喜欢过了~" toView:self.view];
    } else {
        ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:sender.tag];
        dynamc.hasParise = 1;
        dynamc.pcount++;
        [dynamc save];
        sender.selected = YES;
        [ZXPersonalDynamic praiseDynamicWithUid:GLOBAL_UID did:dynamc.did type:1 block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                dynamc.hasParise = 0;
                dynamc.pcount = MAX(0, dynamc.pcount-1);
                [dynamc save];
                sender.selected = NO;;
                [MBProgressHUD showText:errorInfo toView:self.view];
            }
        }];
    }
}

- (IBAction)commentAction:(UIButton *)sender
{
    ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:sender.tag];
    
    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
    vc.did = dynamc.did;
    vc.type = 1;
    vc.dynamic = dynamc;
    vc.isCachedDynamic = YES;
    vc.needShowComment = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - loaddata
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
//    [self.tableView headerBeginRefreshing];
}

- (void)loadData
{
    NSString *time = @"";
    if (self.dataArray.count > 0) {
        ZXPersonalDynamic *dynamic = [[ZXPersonalDynamic where:@{@"sid":@([ZXUtils sharedInstance].currentSchool.sid),@"type":@(1),@"isTemp":@NO} order:@{@"cdate":@"ASC"} limit:@1] firstObject];
        time = dynamic.cdate;
    }
    [ZXPersonalDynamic getLatestSchoolDynamicWithUid:GLOBAL_UID time:time pageSize:pageCount sid:[ZXUtils sharedInstance].currentSchool.sid block:^(NSArray *array, NSError *error) {
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
            predicate = [NSPredicate predicateWithFormat:@"(sid == %@) AND (isTemp == %@) AND (type == %@)",@([ZXUtils sharedInstance].currentSchool.sid) ,@NO,@(1)];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"(sid == %@) AND (cdate < %@) AND (isTemp == %@) AND (type == %@)",@([ZXUtils sharedInstance].currentSchool.sid), time,@NO,@(1)];
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
            [self configureBlankView];
            
            if (array.count < pageCount) {
                hasCache = NO;
            }
        });
    });
}

- (void)loadFirstCache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSArray *arrary = [ZXPersonalDynamic where:@{@"sid":@([ZXUtils sharedInstance].currentSchool.sid),@"type":@(1),@"isTemp":@NO} order:@{@"cdate" : @"DESC"} limit:@(pageCount)];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:arrary];
            [self.tableView reloadData];
            [self.tableView headerBeginRefreshing];
            if (arrary.count < pageCount) {
                hasCache = NO;
            }
        });
    });
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

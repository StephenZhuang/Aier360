//
//  ZXParentDynamicViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/15.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXParentDynamicViewController.h"
#import "ZXPersonalDynamic+ZXclient.h"
#import "NSManagedObject+ZXRecord.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "ZXParentDynamicCell.h"
#import "ZXPersonalDyanmicDetailViewController.h"
#import "ZXReleaseMyDynamicViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXPopMenu.h"
#import "ZXCollection+ZXclient.h"
#import "ZXCommentViewController.h"
#import "ZXDynamicMessage+ZXclient.h"
#import "UIViewController+ZXPhotoBrowser.h"
#import "ZXManagedUser.h"
#import "ZXUserProfileViewController.h"
#import "ZXMyProfileViewController.h"
#import "ZXSquareDynamicsViewController.h"

@implementation ZXParentDynamicViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXParentDynamicViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCircleItem];
    
    [self loadFirstData];
}

- (void)loadFirstData
{
    hasCache = YES;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSArray *arrary = [ZXPersonalDynamic where:@{@"sid":@(0),@"isTemp":@(NO)} order:@{@"cdate" : @"DESC"} limit:@(pageCount)];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.dataArray addObjectsFromArray:arrary];
            [self.tableView reloadData];
            [self.tableView headerBeginRefreshing];
            if (arrary.count < pageCount) {
                hasCache = NO;
            }
        });
    });
}

- (void)initCircleItem
{
    self.title = @"好友圈";
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dynamic_bt_newrelease"] style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
//    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
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
//    [self.tableView headerBeginRefreshing];
}

- (void)loadData
{
    NSString *time = @"";
    if (self.dataArray.count > 0) {
        ZXPersonalDynamic *dynamic = [[ZXPersonalDynamic where:@{@"sid":@(0),@"isTemp":@(NO)} order:@{@"cdate":@"ASC"} limit:@(1)] firstObject];
        
        time = dynamic.cdate;
    }
    [ZXPersonalDynamic getLatestParentDynamicWithUid:GLOBAL_UID time:time pageSize:pageCount block:^(NSArray *array, NSError *error) {
//        [self.dataArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
//        [self.dataArray removeAllObjects];
//        [self.tableView reloadData];
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
    
    [ZXPersonalDynamic getOlderParentDynamicWithUid:GLOBAL_UID time:time pageSize:pageCount block:^(NSArray *array, NSError *error) {
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
            predicate = [NSPredicate predicateWithFormat:@"(sid == 0) AND (isTemp == %@)",@(NO)];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"(sid == 0) AND (cdate < %@) AND (isTemp == %@)", time,@(NO)];
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
    return [tableView fd_heightForCellWithIdentifier:@"ZXParentDynamicCell" cacheByIndexPath:indexPath configuration:^(ZXParentDynamicCell *cell) {
        [cell configureWithDynamic:dynamic];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(&*self)weakSelf = self;
    ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
    ZXParentDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXParentDynamicCell"];
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
    cell.repostClickBlock = ^(void) {
        if (dynamic.dynamic) {
            ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
            vc.did = dynamic.dynamic.did;
            vc.type = 2;
            vc.dynamic = dynamic.dynamic;
            vc.isCachedDynamic = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    cell.squareLabelBlock = ^(NSInteger oslid) {
        ZXSquareDynamicsViewController *vc = [ZXSquareDynamicsViewController viewControllerFromStoryboard];
        vc.oslid = oslid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.favButton.tag = indexPath.section;
    cell.actionButton.tag = indexPath.section;
    cell.commentButton.tag = indexPath.section;
    cell.deleteButton.tag = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:indexPath.section];
    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
    vc.did = dynamc.did;
    vc.type = 2;
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
        if (self.needCache) {
            [dynamc save];
        }
        sender.selected = YES;
        [ZXPersonalDynamic praiseDynamicWithUid:GLOBAL_UID did:dynamc.did type:3 block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                dynamc.hasParise = 0;
                dynamc.pcount = MAX(0, dynamc.pcount-1);
                if (self.needCache) {
                    [dynamc save];
                }
                sender.selected = NO;
                [MBProgressHUD showText:errorInfo toView:self.view];
            }
        }];
    }
}

- (IBAction)deleteAction:(UIButton *)sender
{
    ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:sender.tag];

    [ZXPersonalDynamic deleteDynamicWithDid:dynamic.did type:dynamic.type block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [dynamic delete];
            if (self.needCache) {
                [dynamic save];
            }
        } else {
        }
    }];
    [self.dataArray removeObject:dynamic];
    [self.tableView reloadData];
}

- (IBAction)commentAction:(UIButton *)sender
{
    ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:sender.tag];
//    ZXCommentViewController *vc = [ZXCommentViewController viewControllerFromStoryboard];
//    vc.type = 3;
//    vc.did = dynamc.did;
//    vc.commentBlock = ^(void) {
//        dynamc.ccount++;
//        [dynamc save];
//        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:sender.tag]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    };
//    vc.view.frame = self.view.bounds;
//    [self.view addSubview:vc.view];
    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
    vc.did = dynamc.did;
    vc.type = 2;
    vc.dynamic = dynamc;
    vc.isCachedDynamic = YES;
    vc.needShowComment = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)moreAction:(UIButton *)sender
{
    CGRect frame = [sender convertRect:sender.frame toView:self.view];
    
    ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:sender.tag];
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    if (dynamic.type == 3 && dynamic.uid != GLOBAL_UID) {
        [contents addObject:@"转发至好友圈"];
    }
    if (dynamic.hasCollection == 1) {
        [contents addObject:@"取消收藏"];
    } else {
        [contents addObject:@"收藏"];
    }
    if (GLOBAL_UID == dynamic.uid) {
        [contents addObject:@"删除"];
    }
    __weak __typeof(&*self)weakSelf = self;
    ZXPopMenu *menu = [[ZXPopMenu alloc] initWithContents:contents targetFrame:frame];
    menu.ZXPopPickerBlock = ^(NSInteger index) {
        NSString *string = [contents objectAtIndex:index];
        if ([string isEqualToString:@"转发至好友圈"]) {
            ZXReleaseMyDynamicViewController *vc = [ZXReleaseMyDynamicViewController viewControllerFromStoryboard];
            vc.isRepost = YES;
            vc.dynamic = dynamic;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"删除"]) {
            MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
            [ZXPersonalDynamic deleteDynamicWithDid:dynamic.did type:dynamic.type block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@""];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [hud turnToError:errorInfo];
                }
            }];
        } else {
            BOOL isAdd = dynamic.hasCollection==0;
            [ZXCollection collectWithUid:GLOBAL_UID did:dynamic.did isAdd:isAdd block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    if (isAdd) {
                        dynamic.hasCollection = 1;
                    } else {
                        dynamic.hasCollection = 0;
                    }
                } else {
                    [MBProgressHUD showText:errorInfo toView:self.view];
                }
            }];
        }
    };
    [self.view addSubview:menu];
    
}

#pragma mark - getters and setters
- (NSString *)blankString
{
    return @"这群家伙太懒了，一条动态都没有，去试试添加更多的好友吧!";
}

- (UIImage *)blankImage
{
    return [UIImage imageNamed:@"blank_parentcircle"];
}

- (BOOL)needCache
{
    return YES;
}
@end

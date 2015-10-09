//
//  ZXCollectionViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCollectionViewController.h"
#import "ZXCollection+ZXclient.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "ZXCollectionCell.h"
#import "ZXPersonalDyanmicDetailViewController.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

@implementation ZXCollectionViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"收藏";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)loadData
{
    [ZXCollection getCollectionListWithUid:GLOBAL_UID page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCollection *collection = [self.dataArray objectAtIndex:indexPath.section];
    if (collection.img.length > 0) {
        return 124;
    } else {
        return [tableView fd_heightForCellWithIdentifier:@"ZXCollectionCell" configuration:^(ZXCollectionCell *cell) {
            [cell configureUIWithCollection:collection];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCollectionCell"];
    ZXCollection *collection = [self.dataArray objectAtIndex:indexPath.section];
    [cell configureUIWithCollection:collection];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCollection *collection = [self.dataArray objectAtIndex:indexPath.section];
    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
    vc.did = collection.relativeId;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消收藏";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZXCollection *collection = [self.dataArray objectAtIndex:indexPath.section];
        [ZXCollection collectWithUid:GLOBAL_UID did:collection.relativeId isAdd:NO block:^(BOOL success, NSString *errorInfo) {
            
        }];
        [self.dataArray removeObjectAtIndex:indexPath.section];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

#pragma mark - setters and getters
- (NSString *)blankString
{
    return @"看见喜欢的就收进来吧！";
}

- (UIImage *)blankImage
{
    return [UIImage imageNamed:@"blank_collection"];
}
@end

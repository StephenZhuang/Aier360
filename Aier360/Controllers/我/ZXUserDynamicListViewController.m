//
//  ZXUserDynamicListViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/20.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUserDynamicListViewController.h"
#import "ZXReleaseMyDynamicViewController.h"
#import "ZXPersonalDynamic+ZXclient.h"
#import "ZXPersonalDynamicCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "ZXTimeHelper.h"
#import "ZXPersonalDyanmicDetailViewController.h"
#import "MagicalMacro.h"
#import "ZXManagedUser.h"

@implementation ZXUserDynamicListViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXUserDynamicListViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态";
    if (_uid == GLOBAL_UID) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    self.tableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:248/255.0 alpha:1.0];
}

- (IBAction)addAction:(id)sender
{
    ZXReleaseMyDynamicViewController *vc = [ZXReleaseMyDynamicViewController viewControllerFromStoryboard];
    vc.addSuccess = ^(void) {
        [self.tableView headerBeginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadFirstData{}

- (void)loadData
{
    [ZXPersonalDynamic getPersonalDynamicWithUid:_uid fuid:GLOBAL_UID page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (void)addFooter
{
    [self.tableView addFooterWithCallback:^(void){
        page ++;
        [self loadData];
    }];
}

- (void)addHeader
{
    [self.tableView addHeaderWithCallback:^(void) {
        if (!hasMore) {
            [self.tableView setFooterHidden:NO];
        }
        page = 1;
        hasMore = YES;
        [self loadData];
    }];
    [self.tableView headerBeginRefreshing];
}

- (BOOL)needCache
{
    return NO;
}
@end

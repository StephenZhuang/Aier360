//
//  ZXInfoObserverViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/15.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXInfoObserverViewController.h"
#import "MagicalMacro.h"
#import "ZXDynamic+ZXclient.h"
#import "ZXPersonalDynamic+ZXclient.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "ZXSensitiveDynamicTableViewCell.h"
#import "ZXPersonalDyanmicDetailViewController.h"

@interface ZXInfoObserverViewController ()

@end

@implementation ZXInfoObserverViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InfoObserver" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectedIndex = 1;
    self.title = @"信息监控";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"敏感词" style:UIBarButtonItemStylePlain target:self action:@selector(sensitiveWords)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)sensitiveWords
{
    
}

- (IBAction)dynamicAction:(id)sender
{
    if (!self.dynamicButton.selected) {
        self.dynamicButton.selected = YES;
        self.commentButton.selected = NO;
        self.selectedIndex = 1;
        [self configureAnimation];
        [self.tableView headerBeginRefreshing];
    }
}

- (IBAction)commentAction:(id)sender
{
    if (!self.commentButton.selected) {
        self.commentButton.selected = YES;
        self.dynamicButton.selected = NO;
        self.selectedIndex = 2;
        [self configureAnimation];
        [self.tableView headerBeginRefreshing];
    }
}

- (IBAction)ignoreAll:(id)sender
{
    
}

- (void)configureAnimation
{
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat margin = 0;
        if (self.selectedIndex == 2) {
            margin = SCREEN_WIDTH / 2;
        }
        self.leftMargin.constant = margin;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - load data
- (void)loadData
{
    if (self.selectedIndex == 1) {
        [ZXPersonalDynamic getSensitiveDynamicWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
            [self configureArray:array];
        }];
    } else {
        [ZXDynamic getSensitiveDynamicCommentListWithSid:[ZXUtils sharedInstance].currentSchool.sid page:page pageSize:pageCount uid:GLOBAL_UID block:^(NSArray *array, NSError *error) {
            [self configureArray:array];
        }];
    }
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == 1) {
        ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.row];
        return [tableView fd_heightForCellWithIdentifier:@"ZXSensitiveDynamicTableViewCell" configuration:^(ZXSensitiveDynamicTableViewCell *cell) {
            [cell configureCellWithDynamic:dynamic];
        }];
    } else {
        ZXDynamicComment *comment = [self.dataArray objectAtIndex:indexPath.row];
        return [tableView fd_heightForCellWithIdentifier:@"ZXSensitiveDynamicTableViewCell" configuration:^(ZXSensitiveDynamicTableViewCell *cell) {
            [cell configureCellWithComment:comment];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXSensitiveDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXSensitiveDynamicTableViewCell"];
    if (self.selectedIndex == 1) {
        ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.row];
        [cell configureCellWithDynamic:dynamic];
    } else {
        ZXDynamicComment *comment = [self.dataArray objectAtIndex:indexPath.row];
        [cell configureCellWithComment:comment];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex == 1) {
        ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:indexPath.row];
        ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
        vc.did = dynamc.did;
        vc.isCachedDynamic = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZXDynamicComment *comment = [self.dataArray objectAtIndex:indexPath.row];
        ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
        vc.did = comment.did;
        vc.isCachedDynamic = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

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

@interface ZXInfoObserverViewController ()<SWTableViewCellDelegate,UIAlertViewDelegate>

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
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
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
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView headerBeginRefreshing];
    }
}

- (IBAction)ignoreAll:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要忽略全部动态？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        if (self.selectedIndex == 1) {
            [ZXPersonalDynamic changeSensitiveDynamicStateWithDid:0 sid:[ZXUtils sharedInstance].currentSchool.sid type:1 block:^(BOOL success, NSString *errorInfo) {
                
            }];
        } else {
            [ZXDynamic changeSensitiveDynamicCommentStateWithUid:GLOBAL_UID did:0 type:1 commentType:1 sid:[ZXUtils sharedInstance].currentSchool.sid block:^(BOOL success, NSString *errorInfo) {
                
            }];
        }
    }
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
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
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

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"忽略"];
    if (self.selectedIndex == 2) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] title:@"屏蔽"];
    }
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (self.selectedIndex == 1) {
        ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:indexPath.row];
        [ZXPersonalDynamic changeSensitiveDynamicStateWithDid:dynamc.did sid:[ZXUtils sharedInstance].currentSchool.sid type:index+1 block:^(BOOL success, NSString *errorInfo) {
            
        }];
    } else {
        ZXDynamicComment *comment = [self.dataArray objectAtIndex:indexPath.row];
        [ZXDynamic changeSensitiveDynamicCommentStateWithUid:GLOBAL_UID did:comment.dcid type:index+1 commentType:comment.commentType sid:[ZXUtils sharedInstance].currentSchool.sid block:^(BOOL success, NSString *errorInfo) {
            
        }];
    }
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

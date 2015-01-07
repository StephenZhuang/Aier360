//
//  ZXSchoolMessageListViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/8.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolMessageListViewController.h"
#import "ZXCardHistoryCell.h"
#import "ZXDynamicMessage+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXDynamicDetailViewController.h"

@implementation ZXSchoolMessageListViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息列表";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearMessage)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)clearMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定清空吗？" message:@"此操作不可恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)loadData
{
    [ZXDynamicMessage getDynamicMessageListWithUid:GLOBAL_UID page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXCardHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXDynamicMessage *message = self.dataArray[indexPath.row];
    [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:message.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.AMLabel setText:message.nickname];
    [cell.PMLabel setText:message.content];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDynamicMessage *message = self.dataArray[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    ZXDynamicDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZXDynamicDetailViewController"];
    vc.did = message.did;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        ZXDynamicMessage *message = self.dataArray[indexPath.row];
        [ZXDynamicMessage deleteDynamicMessageWithDmid:message.dmid block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                [MBProgressHUD showText:ZXFailedString toView:self.view];
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [ZXDynamicMessage clearDynamicMessageWithUid:GLOBAL_UID block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                [MBProgressHUD showText:ZXFailedString toView:self.view];
            }
        }];
    }
}
@end

//
//  ZXDynamicMessageViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/8.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicMessageViewController.h"
#import "ZXDynamicMessage+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXPersonalDyanmicDetailViewController.h"
#import "ZXMessageCell.h"

@interface ZXDynamicMessageViewController ()

@end

@implementation ZXDynamicMessageViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXDynamicMessageViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态消息";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearMessage)];
    self.navigationItem.rightBarButtonItem = item;
    
    [ZXDynamicMessage readAllMessageWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid block:^(BOOL success, NSString *errorInfo) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)clearMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定清空吗？" message:@"此操作不可恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [ZXDynamicMessage clearDynamicMessageWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid block:^(BOOL success, NSString *errorInfo) {
                if (!success) {
                    [MBProgressHUD showText:ZXFailedString toView:self.view];
                }
            }];
        }
    }
}

- (void)loadData
{
    [ZXDynamicMessage getAllDynamicMessageListWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDynamicMessage *message = self.dataArray[indexPath.row];
    NSString *content = message.content;
    if (message.type == 3) {
        content = @"❤️";
    }
    return [ZXMessageCell heightForContent:content];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXDynamicMessage *message = self.dataArray[indexPath.row];
    [cell confirgureUIWithDynamicMessage:message];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDynamicMessage *message = self.dataArray[indexPath.row];
    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
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
        ZXDynamicMessage *message = self.dataArray[indexPath.row];
        [ZXDynamicMessage deleteDynamicMessageWithDmid:message.dmid block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                [MBProgressHUD showText:ZXFailedString toView:self.view];
            }
        }];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

#pragma mark - getters and setters
- (NSString *)blankString
{
    return @"还没有人评论你哦！";
}

- (UIImage *)blankImage
{
    return [UIImage imageNamed:@"blank_schoolmessage"];
}

@end

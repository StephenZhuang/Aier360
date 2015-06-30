//
//  ZXParentMessageViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/23.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXParentMessageViewController.h"
#import "ZXDynamicMessage+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXPersonalDyanmicDetailViewController.h"
#import "ZXMessageCell.h"

@implementation ZXParentMessageViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXParentMessageViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessage) name:@"clearPersonalMessage" object:nil];
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
    vc.type = 2;
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
        [ZXDynamicMessage deleteDynamicMessageWithDmid:message.dmid type:2 block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                [MBProgressHUD showText:ZXFailedString toView:self.view];
            }
        }];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [ZXDynamicMessage clearDynamicMessageWithUid:GLOBAL_UID type:2 block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                [MBProgressHUD showText:ZXFailedString toView:self.view];
            }
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clearPersonalMessage" object:nil];
}
@end

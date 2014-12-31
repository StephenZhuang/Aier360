//
//  ZXContactsContentViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 14/12/29.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXContactsContentViewController.h"
#import "ZXFollow+ZXclient.h"
#import "ZXContactsCell.h"
#import "ZXUserDynamicViewController.h"
#import "ChatViewController.h"
#import "NSString+ZXMD5.h"

@implementation ZXContactsContentViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contacts" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXContactsContentViewController"];
}

- (void)loadData
{
    [ZXFollow getFollowListWithUid:GLOBAL_UID state:_type page:page page_size:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXFollow *follow = self.dataArray[indexPath.row];
    ZXContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell configreUIWithFollow:follow];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXFollow *follow = self.dataArray[indexPath.row];
    if (follow.adminFlag == 1) {
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:[follow.account md5] isGroup:NO];
        chatVC.nickName = follow.nickname;
        chatVC.headImage = follow.headimg;
        [self.navigationController pushViewController:chatVC animated:YES];
    } else {        
        ZXUserDynamicViewController *vc = [ZXUserDynamicViewController viewControllerFromStoryboard];
        if (_type == 3) {
            vc.uid = follow.uid;
        } else {
            vc.uid = follow.fuid;
        }
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

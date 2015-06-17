//
//  ZXFriendRequestViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/2.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFriendRequestViewController.h"
#import "ZXRequestFriend+ZXclient.h"
#import "ZXContactsCell.h"
#import "MagicalMacro.h"
#import "ZXMyProfileViewController.h"
#import "ZXUserProfileViewController.h"

@implementation ZXFriendRequestViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新的好友";
    [ZXRequestFriend readFriendRequestWithUid:GLOBAL_UID block:^(BOOL success, NSString *errorInfo) {
        
    }];
}

- (void)addFooter{}

- (void)loadData
{
    [ZXRequestFriend getFriendRequestListWithUid:GLOBAL_UID block:^(NSArray *array, NSError *error) {
        [self configureArrayWithNoFooter:array];
    }];
}

#pragma mark-
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXRequestFriend *requestFriend = [self.dataArray objectAtIndex:indexPath.row];
    NSString *string = requestFriend.content.length > 0?requestFriend.content : @"TA想成为你的好友";
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(SCREEN_WIDTH - 198,2000);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return MAX(56, labelsize.height + 50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXRequestFriend *requestFriend = [self.dataArray objectAtIndex:indexPath.row];
    switch (requestFriend.state) {
        case 0:
        {
            [cell.tagLabel setHidden:YES];
            [cell.agreeButton setHidden:NO];
            [cell.refuseButton setHidden:NO];
            [cell.agreeButton setTag:indexPath.row];
            [cell.refuseButton setTag:indexPath.row];
        }
            break;
        case 1:
        {
            [cell.tagLabel setHidden:NO];
            [cell.tagLabel setText:@"已同意"];
            [cell.agreeButton setHidden:YES];
            [cell.refuseButton setHidden:YES];
        }
            break;
        case 2:
        {
            [cell.tagLabel setHidden:NO];
            [cell.tagLabel setText:@"已拒绝"];
            [cell.agreeButton setHidden:YES];
            [cell.refuseButton setHidden:YES];
        }
            break;
        case 3:
        {
            [cell.tagLabel setHidden:NO];
            [cell.tagLabel setText:@"已超时"];
            [cell.agreeButton setHidden:YES];
            [cell.refuseButton setHidden:YES];
        }
            break;
        default:
            break;
    }
    [cell.addressLabel setText:requestFriend.content.length > 0?requestFriend.content : @"TA想成为你的好友"];
    [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:requestFriend.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.titleLabel setText:requestFriend.nickname];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXRequestFriend *user = [self.dataArray objectAtIndex:indexPath.row];
    if (user.fromUid == GLOBAL_UID) {
        ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
        vc.uid = user.fromUid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZXRequestFriend *requestFriend = [self.dataArray objectAtIndex:indexPath.row];
        [ZXRequestFriend handleFriendRequestWithURfid:requestFriend.rfid type:2 block:^(BOOL success, NSString *errorInfo) {
            
        }];
        [self.dataArray removeObject:requestFriend];
        [self.tableView reloadData];
    }
}

- (IBAction)agreeAction:(UIButton *)sender
{
    ZXRequestFriend *requestFriend = [self.dataArray objectAtIndex:sender.tag];
    requestFriend.state = 1;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [ZXRequestFriend handleFriendRequestWithURfid:requestFriend.rfid type:0 block:^(BOOL success, NSString *errorInfo) {
        if (!success) {
            requestFriend.state = 0;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

- (IBAction)refuseAction:(UIButton *)sender
{
    ZXRequestFriend *requestFriend = [self.dataArray objectAtIndex:sender.tag];
    requestFriend.state = 2;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [ZXRequestFriend handleFriendRequestWithURfid:requestFriend.rfid type:1 block:^(BOOL success, NSString *errorInfo) {
        if (!success) {
            requestFriend.state = 0;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}
@end

//
//  ZXSendAnnouncementMessageViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/11.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSendAnnouncementMessageViewController.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXSendAnnouncementMessageViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSendAnnouncementMessageViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发送短信";
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [ZXAnnounceMessage getSchoolMesCountWithSid:self.announceMessage.sid block:^(BOOL success, NSInteger mesCount, NSString *errorInfo) {
        [hud hide:YES];
        self.mesCount = mesCount;
        [self.tableView reloadData];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.announceMessage.messageNum > 1) {
            return [NSString stringWithFormat:@"通知内容已超出一条短信内容限制，需每人发送%@条",@(self.announceMessage.messageNum)];
        } else {
            return @"";
        }
    } else {
        if (self.mesCount < self.announceMessage.needSendPeopleNum * self.announceMessage.messageNum) {
            return @"短信账户余额不足，点击进入短信账户获取短信";
        } else {
            return @"";
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    } else {
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView = (UITableViewHeaderFooterView *)view;
    footerView.contentView.backgroundColor = [UIColor colorWithRed:247 green:245 blue:237];
    [footerView.textLabel setFont:[UIFont systemFontOfSize:13]];
    if (section == 0) {
        [footerView.textLabel setTextColor:[UIColor colorWithRed:160/255.0 green:159/255.0 blue:159/255.0 alpha:1.0]];
    } else {
        [footerView.textLabel setTextColor:[UIColor colorWithRed:249/255.0 green:74/255.0 blue:74/255.0 alpha:1.0]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1.0]];
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"本次发送对象"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@人",@(self.announceMessage.needSendPeopleNum)]];
        } else {
            [cell.textLabel setText:@"所需短信数量"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@条",@(self.announceMessage.needSendPeopleNum * self.announceMessage.messageNum)]];
        }
    } else {
        [cell.textLabel setText:@"短信账户余额"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@条",@(self.mesCount)]];
        if (self.mesCount < self.announceMessage.needSendPeopleNum * self.announceMessage.messageNum) {
            [cell.detailTextLabel setTextColor:[UIColor colorWithRed:249/255.0 green:74/255.0 blue:74/255.0 alpha:1.0]];
        } else {
            [cell.detailTextLabel setTextColor:[UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1.0]];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)sendMessage:(id)sender
{
    if (self.mesCount < self.announceMessage.needSendPeopleNum * self.announceMessage.messageNum) {
        [MBProgressHUD showText:@"短信账户余额不足，点击进入短信账户获取短信" toView:self.view];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"发送中" toView:self.view];
        [ZXAnnounceMessage sendMessageWithMid:self.announceMessage.mid sid:self.announceMessage.sid phoneContent:self.announceMessage.content block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@"发送成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [hud turnToError:errorInfo];
            }
            
        }];
    }
}
@end

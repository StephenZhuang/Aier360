//
//  ZXSettingsViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSettingsViewController.h"
#import "AppDelegate.h"
#import "ChatDemoUIDefine.h"
#import "ZXPersonalDynamic+ZXclient.h"

@implementation ZXSettingsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    [self.tableView setSeparatorColor:[UIColor colorWithRed:237/255.0 green:235/255.0 blue:229/255.0 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

#pragma mark-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.textColor = [UIColor colorWithRed:95 green:95 blue:95];
    if (indexPath.section == 2) {
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setText:@"退出"];
    } else {
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        if (indexPath.section == 1) {
            [cell.textLabel setText:@"关于爱儿邦"];
        } else {
            [cell.textLabel setText:@"消息提醒"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [self logout];
    } else {
        if (indexPath.section == 1) {
            [self performSegueWithIdentifier:@"about" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"notificationSetting" sender:nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)logout
{
    [ZXPersonalDynamic clearDynamicWhenLogout];
    [GVUserDefaults standardUserDefaults].isLogin = NO;
    //    [GVUserDefaults standardUserDefaults].user = nil;
    [GVUserDefaults standardUserDefaults].account = nil;
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.25 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void) {
        
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.window.rootViewController = nav;
    } completion:^(BOOL isFinished) {
        if (isFinished) {
        }
    }];
    
//    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
//        if (error) {
//            
//        }
//        else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//        }
//    } onQueue:nil];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        if (error) {
            
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    } onQueue:nil];
}
@end

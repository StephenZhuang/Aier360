//
//  ZXMineViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMineViewController.h"
#import "AppDelegate.h"
#import "ZXBaseCell.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXChangePasswordViewController.h"
#import "ZXMyDynamicViewController.h"
#import "ChatDemoUIDefine.h"

@implementation ZXMineViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"notificationSetting" sender:nil];
        }
        else if (indexPath.row == 1) {
            ZXChangePasswordViewController *vc = [[UIStoryboard storyboardWithName:@"Mine" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXChangePasswordViewController"];
            vc.phone = [ZXUtils sharedInstance].user.account;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 2) {
            [self clearCache];
        }
        else {
            [self performSegueWithIdentifier:@"about" sender:nil];
        }
    } else {
        [self logout];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)logout
{
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
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        if (error) {

        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    } onQueue:nil];
}

- (void)clearCache
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    hud.mode = MBProgressHUDModeDeterminate;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        float progress = 0.0f;
        while (progress < 1.0f)
        {
            progress += 0.01f;
            hud.progress = progress;
            usleep(50000);
        }
        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
        [mgr cancelAll];
        [mgr.imageCache clearMemory];
        [mgr.imageCache clearDisk];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [hud turnToSuccess:@""];
        });
    });
}

- (void)addHeader{}
- (void)addFooter{}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 88;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXBaseCell"];
        ZXUser *user = [ZXUtils sharedInstance].user;
        [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [cell.titleLabel setText:user.nickname];
        return cell;
        
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        NSString *text = @"";
        switch (indexPath.row) {
            case 0:
                text = @"消息设置";
                break;
            case 1:
                text = @"修改密码";
                break;
            case 2:
                text = @"清除缓存";
                break;
            case 3:
                text = @"关于爱儿邦";
            default:
                break;
        }
        [cell.textLabel setText:text];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [cell.textLabel setText:@"退出"];
        return cell;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;
    if ([segue.identifier isEqualToString:@"dynamic"]) {
        ZXMyDynamicViewController *vc = segue.destinationViewController;
        vc.changeLogoBlock = ^(void) {
            [weakSelf.tableView reloadData];
            NSDictionary *dic = [[ZXUtils sharedInstance].user keyValues];
            [[GVUserDefaults standardUserDefaults] setUser:dic];
        };
    }
}
@end

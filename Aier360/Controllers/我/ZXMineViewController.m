//
//  ZXMineViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMineViewController.h"
#import "ZXContactsCell.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXMyDynamicViewController.h"
#import "ZXMyProfileViewController.h"

@implementation ZXMineViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    } else {
        if (indexPath.row == 0) {
            
        } else {
            [self performSegueWithIdentifier:@"settings" sender:nil];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 95;
    } else {
        return 52;
    }
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
    if (indexPath.section == 0) {
        ZXContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXContactsCell"];
        ZXUser *user = [ZXUtils sharedInstance].user;
        [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [cell.titleLabel setText:user.nickname];
        [cell.addressLabel setText:[NSString stringWithFormat:@"爱儿号:%@",user.aier]];
        return cell;
        
    } else {
        ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        NSString *text = @"";
        switch (indexPath.row) {
            case 0:
            {
                text = @"收藏夹";
                [cell.logoImage setImage:[UIImage imageNamed:@"mine_collect"]];
            }
                break;
            case 1:
            {
                text = @"我的设置";
                [cell.logoImage setImage:[UIImage imageNamed:@"mine_settings"]];
            }
                break;
            default:
                break;
        }
        [cell.titleLabel setText:text];
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
    } else if ([segue.identifier isEqualToString:@"profile"]) {
        ZXMyProfileViewController *vc = segue.destinationViewController;
        vc.user = [ZXUtils sharedInstance].user;
        vc.changeLogoBlock = ^(void) {
            [weakSelf.tableView reloadData];
            NSDictionary *dic = [[ZXUtils sharedInstance].user keyValues];
            [[GVUserDefaults standardUserDefaults] setUser:dic];
        };
    }
}
@end

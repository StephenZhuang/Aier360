//
//  ZXAnnouncementDetailViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementDetailViewController.h"
#import "ZXAnnouncementReceiverCell.h"
#import "ZXMenuCell.h"
#import "ZXAnnouncementDetailCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "MBProgressHUD+ZXAdditon.h"
#import "UIViewController+ZXPhotoBrowser.h"
#import "ZXPopMenu.h"
#import "UIViewController+ZXProfile.h"
#import "ZXAnnouncementUnreadViewController.h"

@interface ZXAnnouncementDetailViewController ()

@end

@implementation ZXAnnouncementDetailViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXAnnouncementDetailViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"announcement_bt_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [ZXAnnouncement getAnnoucementWithUid:GLOBAL_UID mid:_mid block:^(ZXAnnouncement *announcement, NSError *error) {
        if (announcement) {
            [hud turnToSuccess:@""];
        } else {
            [hud turnToError:@""];
        }
        self.announcement = announcement;
        [self.tableView reloadData];
    }];
    [self.tableView setExtrueLineHidden];
}

- (void)moreAction
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"通知删除后将不可恢复，确定要删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
        [ZXAnnouncement deleteAnnoucementWithMid:_mid block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@"删除成功"];
                !_deleteBlock?:_deleteBlock();
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
    }
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.announcement) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 30;
    } else if (indexPath.row == 1) {
        return [tableView fd_heightForCellWithIdentifier:@"ZXAnnouncementReceiverCell" configuration:^(ZXAnnouncementReceiverCell *cell) {
            [cell configureWithAnnouncement:self.announcement isReceiver:YES];
        }];
    } else if (indexPath.row == 2) {
        return [tableView fd_heightForCellWithIdentifier:@"ZXAnnouncementDetailCell" configuration:^(ZXAnnouncementDetailCell *cell) {
            [cell configureWithAnnouncement:self.announcement];
        }];
    } else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ZXAnnouncementReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAnnouncementReceiverCell"];
        [cell configureWithAnnouncement:self.announcement isReceiver:NO];
        return cell;
    } else if (indexPath.row == 1) {
        ZXAnnouncementReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAnnouncementReceiverCell"];
        [cell configureWithAnnouncement:self.announcement isReceiver:YES];
        return cell;
    } else if (indexPath.row == 2) {
        __weak __typeof(&*self)weakSelf = self;
        ZXAnnouncementDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAnnouncementDetailCell"];
        [cell configureWithAnnouncement:self.announcement];
        cell.imageClickBlock = ^(NSInteger index) {
            NSArray *array = [self.announcement.img componentsSeparatedByString:@","];
            [weakSelf browseImage:array index:index];
        };
        return cell;
    } else {
        ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMenuCell"];
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@人阅读",@(self.announcement.reading)]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self gotoProfileWithUid:self.announcement.uid];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

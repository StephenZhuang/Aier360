//
//  ZXAnnouncementViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementViewController.h"
#import "ZXAnnouncement+ZXclient.h"
#import "ZXAnnouncementCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "UIViewController+ZXProfile.h"

@interface ZXAnnouncementViewController ()

@end

@implementation ZXAnnouncementViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXAnnouncementViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公告";
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_release"] style:UIBarButtonItemStylePlain target:self action:@selector(addAnnouncement)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)addAnnouncement
{
    
}

- (void)loadData
{
    [ZXAnnouncement getAnnoucementListWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXAnnouncement *announcement = self.dataArray[indexPath.section];
    return [tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(ZXAnnouncementCell *cell) {
        [cell configureCellWithAnnouncement:announcement];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXAnnouncement *announcement = self.dataArray[indexPath.section];
    [cell configureCellWithAnnouncement:announcement];
    cell.headButton.tag = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)headButtonAction:(UIButton *)sender
{
    ZXAnnouncement *announcement = self.dataArray[sender.tag];
    [self gotoProfileWithUid:announcement.tid];
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

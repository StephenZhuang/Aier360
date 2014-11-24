//
//  ZXSchoolMenuViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolMenuViewController.h"
#import "ZXMenuCell.h"
#import "ZXAccount+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXProvinceViewController.h"

@implementation ZXSchoolMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSuccess:) name:@"changeSuccess" object:nil];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreAction:)];
    self.navigationItem.rightBarButtonItem = item;
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"获取身份" toView:self.view];
    [ZXAccount getLoginStatusWithUid:[ZXUtils sharedInstance].user.uid block:^(ZXAccount *account , NSError *error) {
        [hud hide:YES];
        if (!error) {
            [ZXUtils sharedInstance].account = account;
            NSDictionary *dic = [account keyValues];
            [GVUserDefaults standardUserDefaults].account = dic;
            
            [self setupDataArray];
            NSLog(@"appstateinfo = %@ ",[[ZXUtils sharedInstance].currentAppStateInfo keyValues]);
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

- (void)changeSuccess:(NSNotification *)notification
{
    [self setupDataArray];
    [self.tableView reloadData];
}

- (NSMutableArray *)setupDataArray
{
    _identity = [ZXUtils sharedInstance].identity;
    _dataArray = [[NSMutableArray alloc] init];
    switch (_identity) {
        case ZXIdentityUnchoosesd:
        {
            [self moreAction:nil];
        }
            break;
        case ZXIdentitySchoolMaster:
        {
            [_dataArray addObject:@[@"公告",@"每日餐饮"]];
//            [_dataArray addObject:@[@"点名统计",@"班级列表",@"教工列表"]];
            [_dataArray addObject:@[@"班级列表",@"教工列表"]];
            [_dataArray addObject:@[@"打卡记录",@"我的IC卡"]];
        }
            break;
        case ZXIdentityClassMaster:
        {
            [_dataArray addObject:@[@"班级动态"]];
            [_dataArray addObject:@[@"公告",@"作业",@"每日餐饮"]];
//            [_dataArray addObject:@[@"点名",@"家长列表"]];
            [_dataArray addObject:@[@"家长列表"]];
            [_dataArray addObject:@[@"打卡记录",@"我的IC卡"]];
        }
            break;
        case ZXIdentityTeacher:
        {
             [_dataArray addObject:@[@"班级动态"]];
             [_dataArray addObject:@[@"公告",@"作业",@"每日餐饮"]];
             [_dataArray addObject:@[@"家长列表"]];
              [_dataArray addObject:@[@"打卡记录",@"我的IC卡"]];
        }
            break;
        case ZXIdentityParent:
        {
            [_dataArray addObject:@[@"班级动态"]];
            [_dataArray addObject:@[@"公告",@"作业",@"每日餐饮"]];
            [_dataArray addObject:@[@"打卡记录",@"我的IC卡"]];
        }
            break;
        case ZXIdentityNone:
            break;
        case ZXIdentityStaff:
        {
            [_dataArray addObject:@[@"公告"]];
            [_dataArray addObject:@[@"打卡记录",@"我的IC卡"]];
        }
            break;
            
        default:
            break;
    }
    return _dataArray;
}



- (IBAction)moreAction:(id)sender
{
    [self performSegueWithIdentifier:@"change" sender:sender];
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        NSArray *arr = _dataArray[section-1];
        return arr.count;
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
        ZXMenuCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ZXMenuCell1"];
        if (_identity == ZXIdentityNone) {
            [cell.itemImage setHidden:NO];
        } else {
            [cell.itemImage setHidden:YES];
            ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
            if (school) {
                [cell.titleLabel setText:school.name];
                [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSchoolLogo:school.slogo]];
            }
        }
        return cell;
    } else {
        ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMenuCell2"];
        NSArray *arr = _dataArray[indexPath.section-1];
        NSString *title = arr[indexPath.row];
        [cell.titleLabel setText:title];
        if ([title isEqualToString:@"公告"]) {
            //TODO: 判读是否有新消息
            [cell.hasNewLabel setHidden:NO];
        } else {
            [cell.hasNewLabel setHidden:YES];
        }
        [cell.logoImage setImage:[UIImage imageNamed:title]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_identity == ZXIdentityNone) {
            ZXProvinceViewController *vc = [[UIStoryboard storyboardWithName:@"School" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXProvinceViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        NSString *string = self.dataArray[indexPath.section - 1][indexPath.row];
        if ([string isEqualToString:@"公告"]) {
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Announcement" bundle:nil] instantiateInitialViewController];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"教工列表"]) {
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Teachers" bundle:nil] instantiateInitialViewController];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"班级列表"]) {
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"Teachers" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXClassListViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"我的IC卡"]) {
            UIViewController *vc = [[UIStoryboard storyboardWithName:@"ICCard" bundle:nil] instantiateInitialViewController];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

//
//  ZXSchoolMenuViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolMenuViewController.h"
#import "ZXMenuCell.h"

@implementation ZXSchoolMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDataArray];
}

- (NSMutableArray *)setupDataArray
{
    [self getIdentity];
    _dataArray = [[NSMutableArray alloc] init];
    switch (_identity) {
        case ZXIdentitySchoolMaster:
        {
            [_dataArray addObject:@[@"公告",@"每日餐饮"]];
            [_dataArray addObject:@[@"点名统计",@"班级列表",@"教工列表"]];
            [_dataArray addObject:@[@"打卡记录",@"我的IC卡"]];
        }
            break;
        case ZXIdentityClassMaster:
        {
            [_dataArray addObject:@[@"班级动态"]];
            [_dataArray addObject:@[@"公告",@"作业",@"每日餐饮"]];
            [_dataArray addObject:@[@"点名",@"家长列表"]];
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

- (void)getIdentity
{
    ZXAccount *account = [ZXUtils sharedInstance].account;
    if (account.appStatus.integerValue == 0) {
        if (account.schoolList.count > 0) {
            ZXSchool *school = [account.schoolList firstObject];
            if (school.appStatusSchool.integerValue == 1) {
                _identity = ZXIdentitySchoolMaster;
            } else {
                if (school.classList.count > 0) {
                    ZXClass *schoolClass = [school.classList firstObject];
                    _identity = schoolClass.appStatusClass.integerValue;
                } else {
                    _identity = ZXIdentityStaff;
                }
            }
            
        } else {
            _identity = ZXIdentityNone;
        }
    } else {
        _identity = ZXIdentityNone;
    }
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
        ZXAccount *account = [ZXUtils sharedInstance].account;
        if (account.schoolList.count > 0) {
            ZXSchool *school = [account.schoolList firstObject];
            [cell.titleLabel setText:school.name];
            [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSchoolLogo:school.slogo]];
        }
        return cell;
    } else {
        ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMenuCell2"];
        NSArray *arr = _dataArray[indexPath.section-1];
        NSString *title = arr[indexPath.row];
        [cell.titleLabel setText:title];
        if ([title isEqualToString:@"公告"]) {
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

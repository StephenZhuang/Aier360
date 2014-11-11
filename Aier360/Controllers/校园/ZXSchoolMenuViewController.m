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
            [_dataArray addObject:@[@"公告",@"每日餐饮"]];
            [_dataArray addObject:@[@"点名统计",@"班级列表",@"教工列表"]];
            [_dataArray addObject:@[@"打卡记录",@"我的IC卡"]];
            break;
        case ZXIdentityClassMaster:
            [_dataArray addObject:@[@"班级动态"]];
            [_dataArray addObject:@[@"公告",@"作业",@"每日餐饮"]];
            [_dataArray addObject:@[@"点名",@"家长列表"];
            [_dataArray addObject:@[@"打卡记录",@"我的IC卡"]];
            break;
        case ZXIdentityTeacher:
            <#statement#>
            break;
        case ZXIdentityParent:
            <#statement#>
            break;
        case ZXIdentityNone:
            <#statement#>
            break;
        case ZXIdentityStaff:
            <#statement#>
            break;
            
        default:
            break;
    }
}

- (void)getIdentity
{
    ZXAccount *account = [GVUserDefaults standardUserDefaults].account;
    if (account.appStatus.integerValue == 0) {
        if (account.schoolList.count > 0) {
            ZXSchool *school = [account.schoolList firstObject];
            _identity = school.appStatusSchool.integerValue;
        } else {
            _identity = ZXIdentityNone;
        }
    } else {
        _identity = ZXIdentityNone;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
}
@end

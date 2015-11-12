//
//  ZXUnreadTeacherViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/12.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUnreadTeacherViewController.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXMenuCell.h"
#import "ZXTeacherInfoViewController.h"

@implementation ZXUnreadTeacherViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXUnreadTeacherViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)addFooter{}

- (void)loadData
{
    [ZXTeacherNew getUnreadTeacherWithSid:self.announcement.sid mid:self.announcement.mid type:self.announcement.type block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
        self.title = [NSString stringWithFormat:@"教师(%@)",@(array.count)];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXTeacherNew *teacher = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell.titleLabel setText:teacher.tname];
    if (teacher.lastLogon) {
        [cell.hasNewLabel setText:@""];
        if ([teacher.sex isEqualToString:@"男"]) {
            [cell.logoImage setImage:[UIImage imageNamed:@"contact_male"]];
        } else {
            [cell.logoImage setImage:[UIImage imageNamed:@"contact_female"]];
        }
        
    } else {
        [cell.logoImage setImage:[UIImage imageNamed:@"contact_sexnone"]];
        [cell.hasNewLabel setText:@"还未登录过"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXTeacherInfoViewController *vc = [ZXTeacherInfoViewController viewControllerFromStoryboard];
    ZXTeacherNew *teacher = [self.dataArray objectAtIndex:indexPath.row];
    vc.teacher = teacher;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

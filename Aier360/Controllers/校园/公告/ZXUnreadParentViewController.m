//
//  ZXUnreadParentViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/12.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUnreadParentViewController.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXMenuCell.h"
#import "ZXParent.h"
#import "ZXStudentInfoViewController.h"

@implementation ZXUnreadParentViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXUnreadParentViewController"];
}

- (void)addFooter{}

- (void)loadData
{
    [ZXTeacherNew getUnreadParentWithSid:self.announcement.sid mid:self.announcement.mid cid:self.cid block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
        self.title = [NSString stringWithFormat:@"家长(%@)",@(array.count)];
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
    ZXParent *parent = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell.titleLabel setText:parent.pname];
    if (parent.lastLogon) {
        [cell.hasNewLabel setText:@""];
        if ([parent.sex isEqualToString:@"男"]) {
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
    ZXStudentInfoViewController *vc = [ZXStudentInfoViewController viewControllerFromStoryboard];
    ZXParent *parent = [self.dataArray objectAtIndex:indexPath.row];
    ZXStudent *student = [[ZXStudent alloc] init];
    student.sname = parent.name_student;
    student.csid = parent.csid;
    vc.student = student;
    vc.cid = self.cid;
    vc.canEdit = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

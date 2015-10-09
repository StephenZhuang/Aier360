//
//  ZXSelectDynamicTypeViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSelectDynamicTypeViewController.h"

@implementation ZXSelectDynamicTypeViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dynamic" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSelectDynamicTypeViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态类型";
}

- (void)loadData
{
    [ZXClass getReleaseClassListWithSid:[ZXUtils sharedInstance].currentSchool.sid uid:GLOBAL_UID block:^(NSArray *array, NSError *error) {
        [self.dataArray addObjectsFromArray:array];
        [self configureArrayWithNoFooter:array];
    }];
}

- (void)addFooter{}

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
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXClass *zxclass = self.dataArray[indexPath.row];
    [cell.textLabel setText:zxclass.cname];
    if ([zxclass.cname isEqualToString:@"学校动态"]) {
        [cell.detailTextLabel setText:@"学校所有成员可见"];
    } else {
        [cell.detailTextLabel setText:@"仅本班级成员可见"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXClass *zxclass = self.dataArray[indexPath.row];
    !_selectTypeBlock?:_selectTypeBlock(zxclass);
    [self.navigationController popViewControllerAnimated:YES];
}
@end

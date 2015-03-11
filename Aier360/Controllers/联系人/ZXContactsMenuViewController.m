//
//  ZXContactsMenuViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXContactsMenuViewController.h"
#import "ZXMenuCell.h"
#import "ZXContactHeader.h"

@interface ZXContactsMenuViewController ()

@end

@implementation ZXContactsMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (CURRENT_IDENTITY == ZXIdentityParent) {
        menuArray = @[@[@"好友"],@[@"班级列表"]];
    } else if (CURRENT_IDENTITY == ZXIdentityStaff) {
        menuArray = @[@[@"好友"],@[@"组织架构"]];
    } else {
        menuArray = @[@[@"好友"],@[@"组织架构",@"班级列表"]];
    }
    
    [self.tableView registerClass:[ZXContactHeader class] forHeaderFooterViewReuseIdentifier:@"contactHeader"];
    [self.tableView setExtrueLineHidden];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return menuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    } else {
        ZXContactHeader *contactHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"contactHeader"];
        [contactHeader.titleLabel setText:@"校园通讯录"];
        return contactHeader;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell.logoImage setImage:[UIImage imageNamed:menuArray[indexPath.section][indexPath.row]]];
    [cell.titleLabel setText:menuArray[indexPath.section][indexPath.row]];
    
    return cell;
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

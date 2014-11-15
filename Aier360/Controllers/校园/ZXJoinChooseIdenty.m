//
//  ZXJoinChooseIdenty.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/15.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXJoinChooseIdenty.h"
#import "ZXSelectCell.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXJoinChooseIdenty

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"加入学校(1/2)";
    [self.dataArray addObject:@"教师"];
    [self.dataArray addObject:@"家长"];
    [self.tableView reloadData];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(goNext)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addHeader{}
- (void)addFooter{}

- (void)goNext
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        
    } else {
        [MBProgressHUD showError:@"请先选择身份" toView:self.view];
    }
}

#pragma -mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请选择你的身份";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
//    view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:132 green:132 blue:134]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:self.dataArray[indexPath.row]];
    return cell;
}
@end

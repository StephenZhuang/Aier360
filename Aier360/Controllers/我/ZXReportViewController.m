//
//  ZXReportViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXReportViewController.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "ZXReportTableViewCell.h"
#import "ZXDynamic+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXReportViewController ()
{
    NSInteger selectedIndex;
}
@end

@implementation ZXReportViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXReportViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"举报";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
    
    selectedIndex = -1;
    [self.tableView setExtrueLineHidden];
}

- (void)submit
{
    [self.view endEditing:YES];
    
    ZXReportTableViewCell *cell = (ZXReportTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    NSString *content = cell.textView.text;
    
    if (content.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
        [ZXDynamic informDynamicWithUid:GLOBAL_UID did:_did type:selectedIndex+1 content:content block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@"举报成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
    } else {
        [MBProgressHUD showText:@"请输入详细内容" toView:self.view];
    }
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == selectedIndex) {
        return 120;
    } else {
        return 55;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"请选择举报原因";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:179/255.0 green:176/255.0 blue:168/255.0 alpha:1.0]];
    [header.textLabel setFont:[UIFont systemFontOfSize:13]];
    header.contentView.backgroundColor = [UIColor colorWithRed:247/255.0 green:245/255.0 blue:237/255.0 alpha:1.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXReportTableViewCell"];
    [cell.titleLabel setText:self.typeArray[indexPath.row]];
    cell.textView.layer.borderWidth = 1;
    cell.textView.layer.borderColor = [UIColor colorWithRed:229/255.0 green:226/255.0 blue:213/255.0 alpha:1.0].CGColor;
    cell.textView.placeholder = @"请描述详细情况，以便我们准确处理!";
    if (indexPath.row == selectedIndex) {
        cell.textView.fd_collapsed = NO;
        [cell.iconImage setHighlighted:YES];
    } else {
        cell.textView.fd_collapsed = YES;
        [cell.iconImage setHighlighted:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex != indexPath.row) {
        selectedIndex = indexPath.row;
        [tableView reloadData];
    }
}

#pragma mark - getters and setters
- (NSArray *)typeArray
{
    return @[@"色情",@"侮辱诋毁",@"欺诈",@"广告骚扰",@"政治反动",@"其他"];
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

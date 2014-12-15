//
//  ZXPraiseListViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/15.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPraiseListViewController.h"
#import "ZXUser+ZXclient.h"
#import "ZXBaseCell.h"

@interface ZXPraiseListViewController ()

@end

@implementation ZXPraiseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"赞过的人";
}

- (void)addFooter{}

- (void)loadData
{
    [ZXUser getPraisedListWithDid:_did block:^(NSArray *array, NSError *error) {
        [self configureArrayWithNoFooter:array];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
    ZXUser *user = [self.dataArray objectAtIndex:indexPath.row];
    [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.titleLabel setText:user.nickname];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: 个人动态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

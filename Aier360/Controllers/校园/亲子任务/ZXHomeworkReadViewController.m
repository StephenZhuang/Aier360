//
//  ZXHomeworkReadViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkReadViewController.h"
#import "ZXHomework+ZXclient.h"
#import "ZXBaseCell.h"
#import "ZXUserDynamicViewController.h"
#import "ZXMyDynamicViewController.h"

@interface ZXHomeworkReadViewController ()

@end

@implementation ZXHomeworkReadViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Homework" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXHomeworkReadViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"阅读详情";
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXHomework getHomeworkReadListWithHid:_hid sid:appStateInfo.sid block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (void)addFooter{}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
    ZXHomeworkRead *read = self.dataArray[indexPath.row];
    [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:read.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.titleLabel setText:read.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     ZXHomeworkRead *read = self.dataArray[indexPath.row];
    if (read.uid == GLOBAL_UID) {
        ZXMyDynamicViewController *vc = [ZXMyDynamicViewController viewControllerFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZXUserDynamicViewController *vc = [ZXUserDynamicViewController viewControllerFromStoryboard];
        vc.uid = read.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
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

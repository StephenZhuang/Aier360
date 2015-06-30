//
//  ZXCardHistoryMenuViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/28.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCardHistoryMenuViewController.h"
#import "ZXBigImageViewController.h"
#import "ZXICCard+ZXclient.h"

@interface ZXCardHistoryMenuViewController ()

@end

@implementation ZXCardHistoryMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"打卡记录";
    [self.dataArray addObject:@"我的记录"];
    if (HASIdentyty(ZXIdentityParent)) {
        [self.dataArray addObject:@"宝宝记录"];
    }
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        [self.dataArray addObjectsFromArray:@[@"教师记录",@"班级记录"]];
    } else if (HASIdentyty(ZXIdentityClassMaster)) {
        [self.dataArray addObject:@"班级记录"];
    }
    
    [self.tableView reloadData];
    
    [ZXICCard checkHasEntranceWithSid:[ZXUtils sharedInstance].currentSchool.sid block:^(BOOL success, NSString *errorInfo) {
        if (!success) {
            ZXBigImageViewController *vc = [ZXBigImageViewController viewControllerFromStoryboard];
            vc.imageName = @"entrance";
            vc.view.frame = self.view.bounds;
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)addHeader{}
- (void)addFooter{}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [self.dataArray objectAtIndex:indexPath.row];
    if ([string isEqualToString:@"我的记录"]) {
        [self performSegueWithIdentifier:@"my" sender:nil];
    } else if ([string isEqualToString:@"教师记录"]) {
        if (HASIdentyty(ZXIdentitySchoolMaster)) {
            [self performSegueWithIdentifier:@"teachers" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"myclass" sender:nil];
        }
    } else if ([string isEqualToString:@"班级记录"]){
        [self performSegueWithIdentifier:@"class" sender:nil];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ICCard" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZXParentHistoryViewController"];
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

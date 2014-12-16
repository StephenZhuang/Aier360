//
//  ZXAboutViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/16.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAboutViewController.h"
#import "ZXPrivacyViewController.h"

@implementation ZXAboutViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于爱儿邦";
    
    [self.dataArray addObjectsFromArray:@[@"给我评分",@"功能介绍",@"帮助"]];
    
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    
    [_viersionLabel setText:[NSString stringWithFormat:@"v%@", info[@"CFBundleShortVersionString"]]];
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
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"features" sender:nil];
    } else {
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)privacyAction:(id)sender
{
    ZXPrivacyViewController *vc = [ZXPrivacyViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

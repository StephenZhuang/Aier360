//
//  ZXDiscoveryViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDiscoveryViewController.h"
#import "ZXMenuCell.h"
#import "ZXParentDynamicViewController.h"

@implementation ZXDiscoveryViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"宝宝秀";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

#pragma mark - topbarview delegate
- (NSInteger)numOfItems
{
    return 3;
}

- (NSInteger)defaultSelectedItem
{
    return 0;
}

- (NSString *)topBarView:(TopBarView *)topBarView nameForItem:(NSInteger)item
{
    if (item == 0) {
        return @"热门";
    } else if (item == 1) {
        return @"广场";
    } else {
        return @"好友";
    }
}

- (void)selectItemAtIndex:(NSInteger)index
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
@end

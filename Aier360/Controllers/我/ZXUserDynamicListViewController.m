//
//  ZXUserDynamicListViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/20.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUserDynamicListViewController.h"
#import "ZXReleaseDynamicViewController.h"

@implementation ZXUserDynamicListViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXUserDynamicListViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)addAction:(id)sender
{
    ZXReleaseDynamicViewController *vc = [ZXReleaseDynamicViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

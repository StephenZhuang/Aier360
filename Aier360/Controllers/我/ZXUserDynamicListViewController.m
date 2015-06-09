//
//  ZXUserDynamicListViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/20.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUserDynamicListViewController.h"
#import "ZXReleaseMyDynamicViewController.h"

@implementation ZXUserDynamicListViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXUserDynamicListViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态";
    if (_uid == GLOBAL_UID) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (IBAction)addAction:(id)sender
{
    ZXReleaseMyDynamicViewController *vc = [ZXReleaseMyDynamicViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData
{
    
}
@end

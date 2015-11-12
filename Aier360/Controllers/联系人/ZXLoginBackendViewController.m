//
//  ZXLoginBackendViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/12.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXLoginBackendViewController.h"
#import "ZXAccount+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXLoginBackendViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contacts" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXLoginBackendViewController"];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ZXAccount loginBackendWithAccount:[ZXUtils sharedInstance].user.account qrcodeid:self.qrcodeid block:^(BOOL success, NSString *errorInfo) {
        [MBProgressHUD showSuccess:@"登录成功" toView:nil];
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
@end

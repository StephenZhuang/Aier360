//
//  ZXBaseViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@implementation ZXBaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackButton];
}

- (void)addBackButton
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    UIImage *image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_n",DEFAULTBACKICON]]    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    item.tintColor = [UIColor whiteColor];
//    [item setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = item;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235 green:235 blue:241]];
}
@end

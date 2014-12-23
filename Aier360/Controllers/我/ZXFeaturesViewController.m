//
//  ZXFeaturesViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/16.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFeaturesViewController.h"

@interface ZXFeaturesViewController ()
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *imageHeight;
@end

@implementation ZXFeaturesViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"功能介绍";
    
    UIImage *image = [UIImage imageNamed:@"Features"];
    
    CGFloat height = self.view.frame.size.width * image.size.height / image.size.width;
    [UIView animateWithDuration:0.25 animations:^{
        _imageHeight.constant = height;
        [self updateViewConstraints];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}
@end

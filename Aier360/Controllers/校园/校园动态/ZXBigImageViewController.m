//
//  ZXBigImageViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/29.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBigImageViewController.h"

@implementation ZXBigImageViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXBigImageViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:_imageName ofType:@"jpg"];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    [_imageView setImage:image];
    
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

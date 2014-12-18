//
//  ZXHelpDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHelpDetailViewController.h"

@implementation ZXHelpDetailViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXHelpDetailViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"帮助";
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"app_login" ofType:@"html"];
    filePath = [NSString stringWithFormat:@"%@?%@",filePath,_parameter];
    NSURL *url = [NSURL URLWithString:filePath];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}
@end

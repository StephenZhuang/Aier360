//
//  ZXPrivacyViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPrivacyViewController.h"
#import "ZXApiClient.h"

@interface ZXPrivacyViewController ()
@property (nonatomic , weak) IBOutlet UIWebView *webView;
@end

@implementation ZXPrivacyViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"服务条款和隐私政策";
//    NSURL *url = [NSURL URLWithString:@"html/declare.html" relativeToURL:[ZXApiClient sharedClient].baseURL];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
}

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXPrivacyViewController"];
}
@end

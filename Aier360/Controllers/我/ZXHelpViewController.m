//
//  ZXHelpViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHelpViewController.h"
#import "ZXHelpDetailViewController.h"

@implementation ZXHelpViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"帮助";
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"app_help" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:filePath];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString hasSuffix:@"app_help.html"]) {
        return YES;
    } else {
        ZXHelpDetailViewController *vc = [ZXHelpDetailViewController viewControllerFromStoryboard];
        NSString *parameter = [[request.URL.absoluteString componentsSeparatedByString:@"?"] lastObject];
        vc.parameter = parameter;
        [self.navigationController pushViewController:vc animated:YES];
    }
    return NO;
}

@end

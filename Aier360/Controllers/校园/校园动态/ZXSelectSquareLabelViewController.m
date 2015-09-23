//
//  ZXSelectSquareLabelViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/23.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSelectSquareLabelViewController.h"

@interface ZXSelectSquareLabelViewController ()

@end

@implementation ZXSelectSquareLabelViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dynamic" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSelectSquareLabelViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

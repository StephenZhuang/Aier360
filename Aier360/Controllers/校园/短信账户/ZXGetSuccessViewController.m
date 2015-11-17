//
//  ZXGetSuccessViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/16.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXGetSuccessViewController.h"

@interface ZXGetSuccessViewController ()

@end

@implementation ZXGetSuccessViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MessageAccount" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXGetSuccessViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
    [self.maskView addGestureRecognizer:tap];
    self.maskView.userInteractionEnabled = YES;
}

- (void)dismissAction
{
    !_dissmissBlock?:_dissmissBlock();
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)setReawrd:(NSString *)reawrd
{
    _reawrd = reawrd;
    [self.reawrdLabel setText:reawrd];
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

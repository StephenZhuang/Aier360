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
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235 green:235 blue:241]];
}

+ (instancetype)viewControllerFromStoryboard
{
    NSLog(@"error:%@ 没有重写viewControllerFromStoryboard方法",NSStringFromClass(self));
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *controllerName = [[ZXUtils sharedInstance].controllerNameDictionary objectForKey:NSStringFromClass([self class])];
    if (!controllerName) {
        controllerName = NSStringFromClass([self class]);
    }
    [MobClick beginLogPageView:controllerName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *controllerName = [[ZXUtils sharedInstance].controllerNameDictionary objectForKey:NSStringFromClass([self class])];
    if (!controllerName) {
        controllerName = NSStringFromClass([self class]);
    }
    [MobClick endLogPageView:controllerName];
}
@end

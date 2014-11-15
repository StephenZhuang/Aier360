//
//  ZXNavigationController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/15.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXNavigationController.h"

@implementation ZXNavigationController
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInterface];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self customInterface];
    }
    return self;
}

- (void)customInterface
{
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:26 green:30 blue:33]];
    NSDictionary* attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationBar setTitleTextAttributes:attrs];

}
@end

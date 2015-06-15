//
//  ZXProfileViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXProfileViewController.h"
#import "UINavigationBar+Awesome.h"
#import "MagicalMacro.h"

#define NAVBAR_CHANGE_POINT 64

@implementation ZXProfileViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self addBackButton];
    [self.tableView setExtrueLineHidden];
    [self.tableView setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
}

- (void)addBackButton
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:247 green:245 blue:237]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.tableView];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:4 green:192 blue:143]];
    NSDictionary* attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:4 green:192 blue:143];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT ) {
        CGFloat alpha = 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64);
        
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    CGFloat ImageWidth = SCREEN_WIDTH;
    CGFloat ImageHeight = 290;
    if (offsetY < 0) {
        CGFloat factor = ((ABS(offsetY)+ImageHeight)*ImageWidth)/ImageHeight;
        CGRect f = CGRectMake(-(factor-ImageWidth)/2, offsetY, factor, ImageHeight+ABS(offsetY));
        self.profileImage.layer.frame = f;
    } else {
        CGFloat ImageWidth = self.profileImage.frame.size.width;
        CGFloat ImageHeight = self.profileImage.frame.size.height;
        CGRect f = CGRectMake(0, 0, ImageWidth, ImageHeight);
        self.profileImage.layer.frame = f;
        
    }
}
@end

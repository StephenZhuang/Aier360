//
//  ZXDiscoveryViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDiscoveryViewController.h"
#import "ZXMenuCell.h"
#import "ZXParentDynamicViewController.h"
#import "ZXReleaseMyDynamicViewController.h"
#import "ZXHotDynamicViewController.h"
#import "ZXSquareViewController.h"

@implementation ZXDiscoveryViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"宝宝秀";
    
    ZXHotDynamicViewController *hot = [ZXHotDynamicViewController viewControllerFromStoryboard];
    ZXSquareViewController *square = [ZXSquareViewController viewControllerFromStoryboard];
    ZXParentDynamicViewController *dynamic = [ZXParentDynamicViewController viewControllerFromStoryboard];
    [self setViewControllers:@[hot,square,dynamic]];
    
}

- (IBAction)addAction:(id)sender
{
    ZXReleaseMyDynamicViewController *vc = [ZXReleaseMyDynamicViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - topbarview delegate
- (NSInteger)numOfItems
{
    return 3;
}

- (NSInteger)defaultSelectedItem
{
    return 0;
}

- (NSString *)topBarView:(TopBarView *)topBarView nameForItem:(NSInteger)item
{
    if (item == 0) {
        return @"热门";
    } else if (item == 1) {
        return @"广场";
    } else {
        return @"好友";
    }
}

- (void)selectItemAtIndex:(NSInteger)index
{
    [self setSelectedIndex:index];
}


#pragma mark - Methods

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];

    } else {
        
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}
@end

//
//  ZXDiscoveryViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "TopBarView.h"

@interface ZXDiscoveryViewController : ZXBaseViewController<TopBarViewDelegate,TopBarViewDataSource,UINavigationControllerDelegate>
@property (nonatomic , weak) IBOutlet TopBarView *topBarView;
@property (nonatomic , weak) IBOutlet UIView *contentView;

/**
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, copy) IBOutletCollection(UIViewController) NSArray *viewControllers;

/**
 * The tab bar view associated with this controller. (read-only)
 */
@property (nonatomic, readonly) RDVTabBar *tabBar;

/**
 * The view controller associated with the currently selected tab item.
 */
@property (nonatomic, weak) UIViewController *selectedViewController;

/**
 * The index of the view controller associated with the currently selected tab item.
 */
@property (nonatomic) NSUInteger selectedIndex;

@end

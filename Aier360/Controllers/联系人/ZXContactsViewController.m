//
//  ZXContactsViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXContactsViewController.h"
#import "TopBarView.h"
#import "ZXContactsContentViewController.h"
#import "ZXAddContactsViewController.h"

@interface ZXContactsViewController ()<TopBarViewDelegate , TopBarViewDataSource>
@property (nonatomic , weak) IBOutlet TopBarView *topbarView;
@property (nonatomic , strong) NSArray *topbarArray;
@property (nonatomic , weak) IBOutlet UIView *contentView;

/**
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic , copy) IBOutletCollection(UIViewController) NSArray *viewControllers;
/**
 * The view controller associated with the currently selected tab item.
 */
@property (nonatomic, weak) UIViewController *selectedViewController;

/**
 * The index of the view controller associated with the currently selected tab item.
 */
@property (nonatomic) NSUInteger selectedIndex;
@end

@implementation ZXContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"联系人";
    _topbarArray = @[@"好友",@"关注",@"粉丝"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_contacts_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addContacts)];
    self.navigationItem.rightBarButtonItem = item;
    
    NSMutableArray *vcArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        ZXContactsContentViewController *vc = [ZXContactsContentViewController viewControllerFromStoryboard];
        NSInteger type = 2;
        if (i == 0) {
            type = 2;
        } else if (i == 1) {
            type = 1;
        } else {
            type = 3;
        }
        vc.type = type;
        [vcArr addObject:vc];
    }
    [self setViewControllers:vcArr];
    [self setSelectedIndex:0];
    
}

- (void)addContacts
{
    [self performSegueWithIdentifier:@"add" sender:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

#pragma -mark topbarview delegate
- (NSInteger)numOfItems
{
    return _topbarArray.count;
}

- (NSString *)topBarView:(TopBarView *)topBarView nameForItem:(NSInteger)item
{
    return _topbarArray[item];
}

- (NSInteger)defaultSelectedItem
{
    return 0;
}

- (void)selectItemAtIndex:(NSInteger)index
{
    [self setSelectedIndex:index];
}

#pragma -mark vc delegate
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
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        [self setSelectedIndex:0];
    } else {
        _viewControllers = nil;
    }
}
@end

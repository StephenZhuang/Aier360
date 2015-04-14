//
//  ZXMyProfileViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/14.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMyProfileViewController.h"
#import "UINavigationBar+Awesome.h"
#import "MagicalMacro.h"

#define NAVBAR_CHANGE_POINT 64

@implementation ZXMyProfileViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self addBackButton];
    [self.tableView setExtrueLineHidden];
    self.headButton.layer.borderWidth = 2;
    self.headButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headButton.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.headButton.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.headButton.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.headButton.layer.shadowRadius = 2;//阴影半径，默认3
}

- (void)addBackButton
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = item;
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:247 green:245 blue:237]];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.tableView];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.tableView setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:@"sas"];
    return cell;
}
@end

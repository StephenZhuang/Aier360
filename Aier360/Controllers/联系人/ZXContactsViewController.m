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

@interface ZXContactsViewController ()
@end

@implementation ZXContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"好友";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_contacts_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addContacts)];
    self.navigationItem.rightBarButtonItem = item;
    
    
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

@end

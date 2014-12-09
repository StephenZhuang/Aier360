//
//  ZXUserMailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUserMailViewController.h"

@implementation ZXUserMailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (CURRENT_IDENTITY(ZXIdentitySchoolMaster)) {
        self.title = @"更多留言";
    } else {
        self.title = @"校长信箱";
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_release"] style:UIBarButtonItemStyleBordered target:self action:@selector(addMail)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)addMail
{
    [self performSegueWithIdentifier:@"add" sender:nil];
}
@end

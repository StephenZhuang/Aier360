//
//  ZXAnnouncementViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementViewController.h"

@interface ZXAnnouncementViewController ()

@end

@implementation ZXAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"公告";
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_release"] style:UIBarButtonItemStylePlain target:self action:@selector(addAnnouncement)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)addAnnouncement
{
    
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

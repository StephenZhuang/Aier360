//
//  ZXSendAnnouncementMessageViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/11.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSendAnnouncementMessageViewController.h"

@implementation ZXSendAnnouncementMessageViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSendAnnouncementMessageViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发送短信";
}
@end

//
//  ZXAddAnnouncementSuccessViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/10.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddAnnouncementSuccessViewController.h"
#import "ZXMessageEditViewController.h"

@implementation ZXAddAnnouncementSuccessViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXAddAnnouncementSuccessViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tipLabel setText:[NSString stringWithFormat:@"本条通知的发布对象中有%@人未激活，他们收不到消息提醒，您可以选择给他们发送短信！",@(self.announceMessage.needSendPeopleNum)]];
    self.checkBox.onAnimationType = BEMAnimationTypeOneStroke;
    self.checkBox.offAnimationType = BEMAnimationTypeOneStroke;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.checkBox setOn:YES animated:YES];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
}

- (IBAction)sendMessageAction:(id)sender
{
    ZXMessageEditViewController *vc = [ZXMessageEditViewController viewControllerFromStoryboard];
    vc.announceMessage = self.announceMessage;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

//
//  UIViewController+ZXProfile.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "UIViewController+ZXProfile.h"
#import "ZXMyProfileViewController.h"
#import "ZXUserProfileViewController.h"

@implementation UIViewController (ZXProfile)
- (void)gotoProfileWithUid:(long)uid
{
    if (uid == GLOBAL_UID) {
        ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
        vc.uid = uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

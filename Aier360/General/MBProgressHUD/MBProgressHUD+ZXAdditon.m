//
//  MBProgressHUD+ZXAdditon.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "MBProgressHUD+ZXAdditon.h"
#import "UIImage+SZBundleImage.h"

@implementation MBProgressHUD (ZXAdditon)
+ (void)showSuccess:(NSString *)text
{
    [self showWithText:text imageName:@"success-white"];
}

+ (void)showError:(NSString *)text
{
    [self showWithText:text imageName:@"error-white"];
}

+ (void)showWithText:(NSString *)text imageName:(NSString *)imageName
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imagesNamedFromCustomBundle:imageName]];
    
    // Set custom view mode
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:2];
}

+ (void)showText:(NSString *)text
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:2];
}

+ (instancetype)showWaiting:(NSString *)text
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = text;
    
    [hud show:YES];
    return hud;
}

- (void)turnToSuccess:(NSString *)text
{
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imagesNamedFromCustomBundle:@"success-white"]];
    self.mode = MBProgressHUDModeCustomView;
    self.labelText = text;
    [self hide:YES afterDelay:2];
}

- (void)turnToError:(NSString *)text
{
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imagesNamedFromCustomBundle:@"error-white"]];
    self.mode = MBProgressHUDModeCustomView;
    self.labelText = text;
    [self hide:YES afterDelay:2];
}

- (void)turnToText:(NSString *)text
{
    self.mode = MBProgressHUDModeText;
    self.labelText = text;
    [self hide:YES afterDelay:2];
}
@end

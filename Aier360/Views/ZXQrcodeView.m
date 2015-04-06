//
//  ZXQrcodeView.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/31.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXQrcodeView.h"
#import "MagicalMacro.h"
#import <pop/POP.h>
#import "ZXUser+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXQrcodeView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    canHide = NO;
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    _maskView = [[UIView alloc] init];
    _maskView.frame = self.bounds;
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.5;
    [self addSubview:_maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_maskView addGestureRecognizer:tap];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 265, 380)];
    _contentView.center = self.center;
    [self addSubview:_contentView];
    [_contentView setBackgroundColor:[UIColor colorWithRed:255 green:252 blue:248]];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    
    ZXUser *user = [ZXUtils sharedInstance].user;
    
    UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(15, 27, 45, 45)];
    [head sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    head.layer.cornerRadius = 5;
    head.layer.masksToBounds = YES;
    [_contentView addSubview:head];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 43, 180, 20)];
    [nameLabel setText:user.nickname];
    [nameLabel setTextColor:[UIColor colorWithRed:95 green:95 blue:95]];
    [nameLabel setFont:[UIFont systemFontOfSize:17]];
    [_contentView addSubview:nameLabel];
    
    UIImageView *qrcodeView = [[UIImageView alloc] initWithFrame:CGRectMake(32, 100, 200, 200)];
    [_contentView addSubview:qrcodeView];
    
    if (user.qrcode) {
        [qrcodeView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForQrcode:user.qrcode]];
    } else {
        [ZXUser createQrcodeWithUid:GLOBAL_UID qrCodeContent:[NSString stringWithFormat:@"%@html/judgement.html?uid=%@",[ZXApiClient sharedClient].baseURL.absoluteString,@(GLOBAL_UID)] block:^(NSString *qrcode, NSError *error) {
            if (qrcode) {
                user.qrcode = qrcode;
                [qrcodeView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForQrcode:user.qrcode]];
            } else {
                [MBProgressHUD showText:@"二维码生成失败，请重试" toView:nil];
            }
        }];
    }
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(8, 333, 250, 20)];
    [_contentView addSubview:lable];
    lable.textColor = [UIColor colorWithRed:161 green:157 blue:148];
    lable.font = [UIFont systemFontOfSize:17];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"扫一扫二维码，加我爱儿号";
    
    [self showPopup];
}

#pragma  -mark
- (void)hide
{
    [self hidePopup];
}

- (void)showPopup
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5f)];
    scaleAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];//@(0.0f);
    scaleAnimation.springBounciness = 20.0f;
    scaleAnimation.springSpeed = 20.0f;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            canHide = YES;
        }
    };
    [_contentView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)hidePopup
{
    if (!canHide) {
        return;
    }
    canHide = NO;
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(1);
    opacityAnimation.toValue = @(0);
    [_contentView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
    scaleAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    };
    [_contentView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}
@end

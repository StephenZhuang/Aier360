//
//  ZXLoginViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXLoginViewController.h"
#import "ZXAccount+ZXclient.h"
#import "ZXValidateHelper.h"
#import "UIImage+SZBundleImage.h"

@interface ZXLoginViewController()<UITextFieldDelegate>
@property (nonatomic , weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordTextField;
@end

@implementation ZXLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_usernameTextField setText:@"18001508524"];
    [_passwordTextField setText:@"123456"];
}

- (IBAction)loginAction:(id)sender
{
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    if (![ZXValidateHelper checkTel:username]) {
        return;
    }
    if (password.length < 6 || password.length > 12) {
        [MBProgressHUD showError:@"密码需要在6到12位之间"];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"登录中"];
    
    [ZXAccount loginWithAccount:username pwd:password block:^(ZXAccount *account ,NSError *error) {
        if (error) {
            [hud turnToError:@"登录失败"];
        }
        if (account.s) {
            NSLog(@"成功 %i",account.s);
            [hud turnToSuccess:@"登录成功"];
        } else {
            NSLog(@"失败 %i",account.s);
            [hud turnToError:@"登录失败"];
        }
    }];
}

@end

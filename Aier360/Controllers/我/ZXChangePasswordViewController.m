//
//  ZXChangePasswordViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/15.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXChangePasswordViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "BaseModel+ZXRegister.h"
#import "AppDelegate.h"
#import "ChatDemoUIDefine.h"

@interface ZXChangePasswordViewController ()

@property (nonatomic , weak) IBOutlet UITextField *oldPasswordTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordAgainTextField;

@end

@implementation ZXChangePasswordViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"修改密码";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)submit
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:nil];
    NSString *oldPassword = [_oldPasswordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *password = [_passwordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *passwordAgain = [_passwordAgainTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([passwordAgain isEqualToString:password]) {
        if (password.length >= 6 && password.length <= 20) {
            [ZXBaseModel changePasswordWithAccount:_phone password:password oldpwd:oldPassword block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@"修改成功，请重新登录"];
                    [self logout];
                } else {
                    [hud turnToError:errorInfo];
                }
            }];
        } else {
            [hud turnToError:@"密码需要在6-20位之间"];
        }
    } else {
        [hud turnToError:@"两次输入密码不一致"];
    }
}

- (void)logout
{
    [GVUserDefaults standardUserDefaults].isLogin = NO;
//    [GVUserDefaults standardUserDefaults].user = nil;
    [GVUserDefaults standardUserDefaults].account = nil;
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.25 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void) {
        
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.window.rootViewController = nav;
    } completion:^(BOOL isFinished) {
        if (isFinished) {
        }
    }];
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        if (error) {
            
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    } onQueue:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_oldPasswordTextField]) {
        [_passwordTextField becomeFirstResponder];
    } else if ([textField isEqual:_passwordTextField]) {
        [_passwordAgainTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}
@end

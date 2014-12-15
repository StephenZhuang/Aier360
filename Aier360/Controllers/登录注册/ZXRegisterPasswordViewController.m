//
//  ZXRegisterPasswordViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/14.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRegisterPasswordViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXRegisterNickNameViewController.h"
#import "BaseModel+ZXRegister.h"

@implementation ZXRegisterPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_type == 1) {
        
        self.title = @"设置密码(2/3)";
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(goNext)];
        self.navigationItem.rightBarButtonItem = item;
    } else if (_type == 2) {
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)goNext
{
    NSString *password = [_passwordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *passwordAgain = [_passwordAgainTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (passwordAgain.length == password.length) {
        if (password.length >= 6 && password.length <= 20) {
            [self performSegueWithIdentifier:@"nickname" sender:nil];
        } else {
            [MBProgressHUD showError:@"密码需要在6-20位之间" toView:self.view];
        }
    } else {
        [MBProgressHUD showError:@"两次输入密码不一致" toView:self.view];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_passwordTextField]) {
        [_passwordAgainTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"nickname"]) {
        ZXRegisterNickNameViewController *vc = segue.destinationViewController;
        vc.phone = _phone;
        vc.password = _passwordTextField.text;
    }
}
@end

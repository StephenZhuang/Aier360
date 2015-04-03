//
//  ZXRegisterPasswordViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/14.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRegisterPasswordViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "BaseModel+ZXRegister.h"
#import "NSString+ZXMD5.h"

@interface ZXRegisterPasswordViewController ()
@property (nonatomic , weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordAgainTextField;
@end

@implementation ZXRegisterPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置密码(2/2)";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(changeDone)];
    self.navigationItem.rightBarButtonItem = item;
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

- (void)changeDone
{
    [self.view endEditing:YES];
    NSString *password = [_passwordTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *passwordAgain = [_passwordAgainTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (passwordAgain.length == password.length) {
        if (password.length >= 6 && password.length <= 20) {
            MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
            if (_type == 1) {
                [ZXBaseModel registerWithAccount:_phone password:[password md5] block:^(ZXBaseModel *baseModel ,NSError *error) {
                    if (baseModel) {
                        if (baseModel.s) {
                            [hud turnToSuccess:@"注册成功"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"register_success" object:nil userInfo:@{@"account":_phone,@"pwd":password}];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        } else {
                            [hud turnToError:baseModel.error_info];
                        }
                    }
                }];
            } else {
                
                [ZXBaseModel forgetPasswordWithAccount:_phone password:[password md5] block:^(BOOL success, NSString *errorInfo) {
                    if (success) {
                        [hud turnToSuccess:@"修改成功"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        [hud turnToError:errorInfo];
                    }
                }];
            }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}
@end

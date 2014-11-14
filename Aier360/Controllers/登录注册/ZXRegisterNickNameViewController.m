//
//  ZXRegisterNickNameViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/14.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRegisterNickNameViewController.h"
#import "BaseModel+ZXRegister.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXRegisterNickNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置昵称(3/3)";
    
}

- (IBAction)registerAction:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"正在提交" toView:self.view];
    [BaseModel registerWithAccount:_phone password:_password nickName:_nickNameTextField.text block:^(BaseModel *baseModel ,NSError *error) {
        if (baseModel) {
            if (baseModel.s) {
                [hud turnToSuccess:@"注册成功"];
            } else {
                [hud turnToError:baseModel.error_info];
            }
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length > 0) {
        _registerButton.enabled = YES;
    } else {
        _registerButton.enabled = NO;
    }
    return YES;
}
@end

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

@interface ZXRegisterNickNameViewController ()
@property (nonatomic , weak) IBOutlet UITextField *nickNameTextField;
@property (nonatomic , weak) IBOutlet UIButton *registerButton;
@end

@implementation ZXRegisterNickNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置昵称(3/3)";
    
}

- (IBAction)registerAction:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"正在提交" toView:self.view];
    [ZXBaseModel registerWithAccount:_phone password:_password nickName:_nickNameTextField.text block:^(ZXBaseModel *baseModel ,NSError *error) {
        if (baseModel) {
            if (baseModel.s) {
                [hud turnToSuccess:@"注册成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"register_success" object:nil userInfo:@{@"account":_phone,@"pwd":_password}];
                [self.navigationController popToRootViewControllerAnimated:YES];
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

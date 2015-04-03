//
//  ZXRegisterViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRegisterViewController.h"
#import "ZXValidateHelper.h"
#import "BaseModel+ZXRegister.h"
#import "ZXUpDownLoadManager.h"
#import "ZXCountTimeHelper.h"
#import "ZXRegisterPasswordViewController.h"

@interface ZXRegisterViewController ()
{
    NSString *randomString;
}
@property (nonatomic , weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic , weak) IBOutlet UITextField *codeTextField;
@property (nonatomic , weak) IBOutlet UIButton *getCodeButton;
@property (nonatomic , weak) IBOutlet UIButton *privacyButton;
@end

@implementation ZXRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_isRegister) {
        self.title = @"注册(1/2)";
    } else {
        self.title = @"找回密码(1/2)";
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(goNext)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self showVerify];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)goNext
{
    NSString *phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *code = [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![ZXValidateHelper checkTel:phone]) {
        return;
    }
    if (code.length == 0) {
        [MBProgressHUD showError:@"请填写短信验证码" toView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"验证短信中" toView:self.navigationController.view];
    [ZXBaseModel checkCode:code phone:phone block:^(ZXBaseModel *baseModel ,NSError *error) {
        if (baseModel) {
            if (baseModel.s == 1) {
                [hud turnToSuccess:@"验证通过"];
                [self performSegueWithIdentifier:@"password" sender:nil];
            } else {
                [hud turnToError:baseModel.error_info];
            }
        } else {
            [hud turnToError:@"连接失败，请重试"];
        }
    }];
}

- (void)showVerify
{
    [ZXBaseModel getRandomChar:^(NSString *randomChar, NSString *error_info) {
        randomString = randomChar;
    }];
    
}

- (IBAction)getCodeAction:(id)sender
{
    [self.view endEditing:YES];
    NSString *phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![ZXValidateHelper checkTel:phone]) {
        return;
    }
    
    if (!randomString) {
        [MBProgressHUD showError:@"网络情况不好，请返回重试" toView:self.view];
        return;
    }

    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    
    if (_isRegister) {
        
        [ZXBaseModel checkPhoneHasRegister:phone block:^(ZXBaseModel *returnModel ,NSError *error) {
            
            if (returnModel) {
                if (returnModel.s == 1) {
                    _getCodeButton.userInteractionEnabled = NO;
                    [ZXBaseModel getCodeWithAccount:phone randomChar:randomString block:^(ZXBaseModel *baseModel ,NSError *error) {
                        _getCodeButton.userInteractionEnabled = YES;
                        if (baseModel) {
                            if (baseModel.s == 1) {
                                [hud hide:YES];
                                [self startCount];
                                [self showVerify];
                            } else {
                                [hud turnToError:baseModel.error_info];
                                [self showVerify];
                            }
                        } else {
                            [hud turnToError:@"获取验证码失败，请重试"];
                        }
                    }];
                } else {
                    [hud turnToError:returnModel.error_info];
                }
            } else {
                [hud turnToError:error.localizedDescription];
            }
            
        }];
    } else {
        _getCodeButton.userInteractionEnabled = NO;
        [ZXBaseModel getCodeWithAccount:phone randomChar:randomString block:^(ZXBaseModel *baseModel ,NSError *error) {
            _getCodeButton.userInteractionEnabled = YES;
            if (baseModel) {
                if (baseModel.s == 1) {
                    [hud hide:YES];
                    [self startCount];
                    [self showVerify];
                } else {
                    [hud turnToError:baseModel.error_info];
                    [self showVerify];
                }
            } else {
                [hud turnToError:@"获取验证码失败，请重试"];
            }
        }];
    }
    
}

- (void)startCount
{
    [ZXCountTimeHelper countDownWithTime:60 countDownBlock:^(int timeLeft) {
        int seconds = timeLeft % 60;
        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
        //设置界面的按钮显示 根据自己需求设置
        [_getCodeButton setTitle:[NSString stringWithFormat:@"(%@)s",strTime] forState:UIControlStateNormal];
        [_getCodeButton setTitle:[NSString stringWithFormat:@"(%@)s",strTime] forState:UIControlStateSelected];
        _getCodeButton.userInteractionEnabled = NO;
        _getCodeButton.selected = YES;
    } endBlock:^(void) {
        [_getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_getCodeButton setTitle:@"重新获取" forState:UIControlStateSelected];
        _getCodeButton.userInteractionEnabled = YES;
        _getCodeButton.selected = NO;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"password"]) {
        ZXRegisterPasswordViewController *vc = segue.destinationViewController;
        vc.phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        vc.type = _isRegister?1:2;
    }
}
@end

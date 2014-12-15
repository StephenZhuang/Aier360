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

@implementation ZXRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册(1/3)";
    
    item = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(goNext)];
    item.enabled = NO;
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
    int i = arc4random_uniform(100);
    _verifyTextField.text = @"";
    
    [ZXUpDownLoadManager downloadTaskWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"testvali.jpg?%i",i] relativeToURL:[ZXApiClient sharedClient].baseURL].absoluteString completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response1 = (NSHTTPURLResponse *)response;
            NSString *cookieString = response1.allHeaderFields[@"Set-Cookie"];
            if (cookieString) {
                [[ZXApiClient sharedClient].requestSerializer setValue:cookieString forHTTPHeaderField:@"Set-Cookie"];
            }
        }
        [_verifyImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:filePath]]];
        
        [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
    }];
    
}

- (IBAction)changeVerify:(id)sender
{
    [self showVerify];
}

- (IBAction)getCodeAction:(id)sender
{
    NSString *phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *verify = [_verifyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![ZXValidateHelper checkTel:phone]) {
        return;
    }
    if (verify.length == 0) {
        [MBProgressHUD showError:@"请填写图形验证码" toView:self.view];
        return;
    }
    
    [ZXBaseModel checkPhoneHasRegister:phone block:^(ZXBaseModel *returnModel ,NSError *error) {

        if (returnModel) {
            if (returnModel.s == 1) {
                _getCodeButton.userInteractionEnabled = NO;
                [ZXBaseModel getCodeWithAccount:phone authCode:verify block:^(ZXBaseModel *baseModel ,NSError *error) {
                    _getCodeButton.userInteractionEnabled = YES;
                    if (baseModel) {
                        if (baseModel.s == 1) {
                            [self startCount];
                            [self showVerify];
                        } else {
                            [MBProgressHUD showError:baseModel.error_info toView:self.view];
                            [self showVerify];
                        }
                    } else {
                        [MBProgressHUD showError:@"获取验证码失败，请重试" toView:self.view];
                    }
                }];
            } else {
                [MBProgressHUD showError:returnModel.error_info toView:self.view];
            }
        }
        
    }];
    
}

- (void)startCount
{
    [ZXCountTimeHelper countDownWithTime:60 countDownBlock:^(int timeLeft) {
        int seconds = timeLeft % 60;
        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
        //设置界面的按钮显示 根据自己需求设置
        [_getCodeButton setTitle:[NSString stringWithFormat:@"(%@)秒后重新发送",strTime] forState:UIControlStateNormal];
        _getCodeButton.enabled = NO;
    } endBlock:^(void) {
        [_getCodeButton setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        _getCodeButton.enabled = YES;
    }];
}

- (IBAction)agreeAction:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    item.enabled = sender.selected;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:_codeTextField]) {
        [UIView animateWithDuration:0.25 animations:^(void) {
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_codeTextField]) {
        [UIView animateWithDuration:0.25 animations:^(void) {
            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -120);
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"password"]) {
        ZXRegisterPasswordViewController *vc = segue.destinationViewController;
        vc.phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        vc.type = 1;
    }
}
@end

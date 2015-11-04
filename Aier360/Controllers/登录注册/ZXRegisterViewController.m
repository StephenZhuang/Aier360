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
#import "RDVTabBarItem.h"
#import "ChatDemoUIDefine.h"
#import "ZXAccount+ZXclient.h"
#import "NSString+ZXMD5.h"
#import "AppDelegate.h"

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

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXRegisterViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    
    [self showVerify];
    
    if ([GVUserDefaults standardUserDefaults].user) {
        ZXUser *user = [ZXUser objectWithKeyValues:[GVUserDefaults standardUserDefaults].user];
        _phoneTextField.text = user.account;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)loginAction:(id)sender
{
    [self.view endEditing:YES];
    NSString *phone = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *code = [_codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![ZXValidateHelper checkTel:phone]) {
        return;
    }
    if (code.length == 0) {
        [MBProgressHUD showError:@"请填写短信验证码" toView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"登录中" toView:self.view];
    
    [ZXAccount loginWithAccount:phone message:code block:^(ZXUser *user ,NSError *error) {
        if (error) {
            [hud turnToError:@"登录失败"];
        }
        if (user) {
            [hud turnToSuccess:@"登录成功"];
            [ZXUtils sharedInstance].user = user;
            NSDictionary *dic = [user keyValues];
            [[GVUserDefaults standardUserDefaults] setUser:dic];
            [[GVUserDefaults standardUserDefaults] setIsLogin:YES];
            [self setupViewControllers];
            
            NSString *usernameMD5 = [phone md5];
            NSString *passwordMD5 = user.pwd;
            
            [GVUserDefaults standardUserDefaults].password = passwordMD5;
            
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:usernameMD5
                                                                password:passwordMD5
                                                              completion:
             ^(NSDictionary *loginInfo, EMError *aError) {
                 if (loginInfo && !aError) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                     EMError *bError = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                     if (!bError) {
                         bError = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                     }
                 }else {
                     //上报错误并重连
                     __weak __typeof(&*self)weakSelf = self;
                     [weakSelf loginHuanxin:usernameMD5 pwd:passwordMD5];
                     
                 }
             } onQueue:nil];
            
        } else {
            [hud turnToError:@"登录失败"];
        }
    }];
}

- (void)loginHuanxin:(NSString *)username pwd:(NSString *)pwd {
    [ZXAccount uploadEMErrorWithUid:GLOBAL_UID block:^(BOOL success, NSString *errorInfo) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:pwd
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *aError) {
             if (loginInfo && !aError) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                 EMError *bError = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                 if (!bError) {
                     bError = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                 }
             }else {
                 switch (aError.errorCode) {
                     case EMErrorServerNotReachable:
                         [MBProgressHUD showText:@"连接服务器失败!" toView:nil];
                         break;
                     case EMErrorServerAuthenticationFailure:
                         [MBProgressHUD showText:[NSString stringWithFormat:@"环信 %@",aError.description] toView:nil];
                         break;
                     case EMErrorServerTimeout:
                         [MBProgressHUD showText:@"连接服务器超时!" toView:nil];
                         break;
                     default:
                         [MBProgressHUD showText:@"登录失败!" toView:nil];
                         break;
                 }
                 
             }
         } onQueue:nil];
    }];
}

- (void)setupViewControllers
{
    NSArray *vcNameArr = @[@"School",@"Message",@"Discovery",@"Mine"];
    NSArray *titleArray = @[@"校园" , @"消息" , @"宝宝秀", @"个人"];
    NSMutableArray *vcArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < vcNameArr.count; i++) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:vcNameArr[i] bundle:nil];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        [vc setTitle:titleArray[i]];
        [vcArr addObject:vc];
    }
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:vcArr];
    [tabBarController setHidesBottomBarWhenPushed:YES];
    
    [self customizeTabBarForController:tabBarController];
    
//    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.25 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void) {
//        
//    } completion:^(BOOL isFinished) {
//        if (isFinished) {
//        }
//    }];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.type = @"cube";
    transition.subtype = kCATransitionFromRight;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.window.rootViewController = nav;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"animation"];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        UIImage *finishedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_s",
                                                      @(index+1)]];
        UIImage *unfinishedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_n",
                                                        @(index+1)]];
        
        UIImage *bgImg = [UIImage imageNamed:@"kong"];
        [item setBackgroundSelectedImage:bgImg withUnselectedImage:bgImg];

        [item setFinishedSelectedImage:finishedImage withFinishedUnselectedImage:unfinishedImage];
        
        index++;
    }
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

- (void)startCount
{
    [ZXCountTimeHelper countDownWithTime:60 countDownBlock:^(int timeLeft) {
        int seconds = timeLeft % 60;
        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
        //设置界面的按钮显示 根据自己需求设置
        [_getCodeButton setTitle:[NSString stringWithFormat:@"%@ s",strTime] forState:UIControlStateNormal];
        [_getCodeButton setTitle:[NSString stringWithFormat:@"%@ s",strTime] forState:UIControlStateSelected];
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
@end

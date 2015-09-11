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
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "ZXRegisterViewController.h"
#import "ChatDemoUIDefine.h"
#import "NSString+ZXMD5.h"
#import "MagicalMacro.h"

@interface ZXLoginViewController ()
@property (nonatomic , weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic , weak) IBOutlet UIImageView *logoImage;
@end

@implementation ZXLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _logoImage.layer.cornerRadius = SCREEN_WIDTH * 0.2;
    _logoImage.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess:) name:@"register_success" object:nil];
    
    if ([GVUserDefaults standardUserDefaults].user) {
        ZXUser *user = [ZXUser objectWithKeyValues:[GVUserDefaults standardUserDefaults].user];
        _usernameTextField.text = user.account;
        [_logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"head_default"]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
}

- (void)textChanged:(NSNotification *)notification
{
    ZXUser *user = [ZXUser objectWithKeyValues:[GVUserDefaults standardUserDefaults].user];
    UITextField *textField = [notification object];
    if (textField == _usernameTextField) {
        if ([_usernameTextField.text isEqualToString:user.account]) {
            [_logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"head_default"]];
        } else {
            [_logoImage setImage:[UIImage imageNamed:@"head_default"]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)loginAction:(id)sender
{
    NSString *username = [_usernameTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *password = _passwordTextField.text;
    if (![ZXValidateHelper checkTel:username]) {
        return;
    }
    if (password.length < 6 || password.length > 20) {
        [MBProgressHUD showError:@"密码需要在6到20位之间" toView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"登录中" toView:self.view];
    
    [ZXAccount loginWithAccount:username pwd:[password md5] block:^(ZXUser *user ,NSError *error) {
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
            
            NSString *usernameMD5 = [username md5];
            NSString *passwordMD5 = [password md5];
            
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
//                     switch (aError.errorCode) {
//                         case EMErrorServerNotReachable:
//                             [MBProgressHUD showText:@"连接服务器失败!" toView:nil];
//                             break;
//                         case EMErrorServerAuthenticationFailure:
//                             [MBProgressHUD showText:[NSString stringWithFormat:@"环信 %@",aError.description] toView:nil];
//                             break;
//                         case EMErrorServerTimeout:
//                             [MBProgressHUD showText:@"连接服务器超时!" toView:nil];
//                             break;
//                         default:
//                             [MBProgressHUD showText:@"登录失败!" toView:nil];
//                             break;
//                     }
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
    [self.navigationController pushViewController:tabBarController animated:YES];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    //    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    //    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    //    UIImage *finishedImage = [UIImage imageNamed:@"img_nofull@2x.png"];
    //    UIImage *unfinishedImage = [UIImage imageNamed:@"img_nofull@2x.png"];
    
//    NSArray *vcNameArr = @[@"tongchengyaoyue",@"quanchengshangjia",@"tuangou",@"wode",@"gengduo"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        UIImage *finishedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_s",
                                                      @(index+1)]];
        UIImage *unfinishedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_%@_n",
                                                        @(index+1)]];
        
        UIImage *bgImg = [UIImage imageNamed:@"kong"];
        [item setBackgroundSelectedImage:bgImg withUnselectedImage:bgImg];
        //        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
        //                                                      [tabBarItemImages objectAtIndex:index]]];
        //        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
        //                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:finishedImage withFinishedUnselectedImage:unfinishedImage];
        //        [item setTitle:vcNameArr[index]];
        
        index++;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)registerSuccess:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    _usernameTextField.text = userInfo[@"account"];
    _passwordTextField.text = userInfo[@"pwd"];
    
    [self performSelector:@selector(loginAction:) withObject:nil afterDelay:0.5];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ZXRegisterViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"register"]) {
        vc.isRegister = YES;
    } else if ([segue.identifier isEqualToString:@"forget"]) {
        vc.isRegister = NO;
    }
}

@end

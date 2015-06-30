//
//  AppDelegate.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/5.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "AppDelegate.h"
#import "ZXApiClient.h"
#import <CoreDataManager.h>
#import "GVUserDefaults+ZXUtil.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "APService.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ChatDemoUIDefine.h"
#import "NSString+ZXMD5.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXMyProfileViewController.h"
#import "ZXUserProfileViewController.h"
#import "ZXAccount+ZXclient.h"
#import "ZXRemoteNotification.h"
#import "JKNotifier.h"
#import "ZXPersonalDyanmicDetailViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    [ZXApiClient sharedClient];
    CoreDataManager *manager = [CoreDataManager sharedManager];
    manager.databaseName = @"Aier360";
    manager.modelName = @"Aier360";
    
    [self setupUMeng];
    [self setupWeixin];
    [self setUpJPushWithOptions:launchOptions];
    [self setupEaseMob:launchOptions application:application];
    
    if ([GVUserDefaults standardUserDefaults].isLogin) {
        ZXUser *user = [ZXUser objectWithKeyValues:[GVUserDefaults standardUserDefaults].user];
        
        NSString *usernameMD5 = [user.account md5];
        
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:usernameMD5
                                                            password:[GVUserDefaults standardUserDefaults].password
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *aError) {
             if (loginInfo && !aError) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                 EMError *bError = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                 if (!bError) {
                     bError = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                 }
             }else {
//                 switch (aError.errorCode) {
//                     case EMErrorServerNotReachable:
//                         [MBProgressHUD showText:@"连接服务器失败!" toView:nil];
//                         break;
//                     case EMErrorServerAuthenticationFailure:
//                         [MBProgressHUD showText:[NSString stringWithFormat:@"环信 %@",aError.description] toView:nil];
//                         break;
//                     case EMErrorServerTimeout:
//                         [MBProgressHUD showText:@"连接服务器超时!" toView:nil];
//                         break;
//                     default:
//                         [MBProgressHUD showText:@"登录失败!" toView:nil];
//                         break;
//                 }
                 //上报错误并处理
                 __weak __typeof(&*self)weakSelf = self;
                 [weakSelf loginHuanxin:usernameMD5 pwd:[GVUserDefaults standardUserDefaults].password];
             }
         } onQueue:nil];
        
        [ZXUtils sharedInstance].user = user;
        [self setupViewControllers];
    } else {
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = nav;
    }
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26 green:30 blue:33]];
//    NSDictionary* attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
//    [[UINavigationBar appearance] setTitleTextAttributes:attrs];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    if(IOS8_OR_LATER && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
//        [[UINavigationBar appearance] setTranslucent:NO];
//    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupUMeng
{
    [MobClick startWithAppkey:@"54f670eafd98c5efc7000747" reportPolicy:BATCH channelId:@""];
    [MobClick setEncryptEnabled:YES];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];

}

- (void)setupWeixin
{
    [WXApi registerApp:@"wx6ec038c7794dba76"];
}

- (void)setupViewControllers
{
    NSArray *vcNameArr = @[@"School",@"Message",@"Contacts",@"Discovery",@"Mine"];
    NSArray *titleArray = @[@"校园",  @"消息" , @"联系人" ,@"发现" , @"个人"];
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
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    self.window.rootViewController = nav;
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
        //        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
        //                                                      [tabBarItemImages objectAtIndex:index]]];
        //        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
        //                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:finishedImage withFinishedUnselectedImage:unfinishedImage];
        //        [item setTitle:vcNameArr[index]];
        
        index++;
    }
}

#pragma mark- 环信
- (void)setupEaseMob:(NSDictionary *)launchOptions application:(UIApplication *)application
{
    _connectionState = eEMConnectionConnected;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"dev";
#else
    apnsCertName = @"dis";
#endif
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"919335417#testdemo" apnsCertName:apnsCertName];
    
#if DEBUG
    [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
#endif
    [[[EaseMob sharedInstance] chatManager] setIsAutoFetchBuddyList:YES];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //以下一行代码的方法里实现了自动登录，异步登录，需要监听[didLoginWithInfo: error:]
    //demo中此监听方法在MainViewController中
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    [self loginStateChange:nil];
}

-(void)loginStateChange:(NSNotification *)notification
{
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {

    }else{
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = nav;
    }
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

#pragma mark- JPush
- (void)setUpJPushWithOptions:(NSDictionary *)launchOptions
{
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    }
    [self handleRemoteNotification:userInfo];
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"注册推送失败");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    completionHandler(UIBackgroundFetchResultNewData);
    
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    }
    [self handleRemoteNotification:userInfo];
    
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    ZXRemoteNotification *notification = [ZXRemoteNotification objectWithKeyValues:userInfo];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [JKNotifier showNotifer:notification.aps.alert];
//        [JKNotifier handleClickAction:^(NSString *name,NSString *detail, JKNotifier *notifier) {
//            [notifier dismiss];
//            NSLog(@"AutoHidden JKNotifierBar clicked");
//            [self handleNotification:notification];
//        }];
    } else {
        [self handleNotification:notification];
    }
}

- (void)handleNotification:(ZXRemoteNotification *)notification
{
    if ([GVUserDefaults standardUserDefaults].isLogin) {
        if (((notification.JPushMessageType == ZXNotificationTypeSchoolDynamic || notification.JPushMessageType == ZXNotificationTypeClassDynamic) && notification.sid == [ZXUtils sharedInstance].currentSchool.sid) || notification.JPushMessageType == ZXNotificationTypePersonalDynamic) {
            UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
            RDVTabBarController *tabbarVc = (RDVTabBarController *)[nav topViewController];
            UINavigationController *navgation = (UINavigationController *)tabbarVc.selectedViewController;
            
            ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
            vc.did = notification.did;
            vc.isCachedDynamic = NO;
            if (notification.JPushMessageType == ZXNotificationTypePersonalDynamic) {
                vc.type = 2;
            } else {
                vc.type = 1;
            }
            [navgation pushViewController:vc animated:YES];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [APService setBadge:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[CoreDataManager sharedManager] saveContext];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application { // 清除内存中的图片缓存
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
    [mgr.imageCache clearDisk];
}


#pragma mark - IChatManagerDelegate

- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
}

#pragma mark - EMChatManagerPushNotificationDelegate

- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        NSLog(@"消息推送与设备绑定失败");
    }
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

#pragma mark- 
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.absoluteString hasPrefix:@"aierbon://uid="]) {
        NSString *uid = [url.absoluteString substringFromIndex:14];
        NSLog(@"uid=%@",uid);
        
        if ([GVUserDefaults standardUserDefaults].isLogin) {
            RDVTabBarController *tabbarVC = (RDVTabBarController *)[((UINavigationController *)self.window.rootViewController) topViewController];
            UINavigationController *nav = (UINavigationController *)tabbarVC.selectedViewController;
            
            if (uid.integerValue == GLOBAL_UID) {
                ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
                [nav pushViewController:vc animated:YES];
            } else {
                ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
                vc.uid = uid.integerValue;
                [nav pushViewController:vc animated:YES];
            }
        }
    } else if ([url.absoluteString hasPrefix:@"wx6ec038c7794dba76"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    if ([url.absoluteString hasPrefix:@"aierbon://uid="]) {
//        return YES;
//    }
//    return  [WXApi handleOpenURL:url delegate:self];
//}

- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        SendMessageToWXResp *smresp = (SendMessageToWXResp *)resp;
        if (smresp.errCode == 0) {
            [MBProgressHUD showSuccess:@"分享成功" toView:nil];
        }
    }
}
@end

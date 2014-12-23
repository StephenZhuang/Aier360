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
    
    
    if ([GVUserDefaults standardUserDefaults].isLogin) {
        ZXUser *user = [ZXUser objectWithKeyValues:[GVUserDefaults standardUserDefaults].user];
        [ZXUtils sharedInstance].user = user;
        [self setupViewControllers];
    } else {
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        self.window.rootViewController = nav;
    }
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26 green:30 blue:33]];
    NSDictionary* attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:attrs];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    if(IOS8_OR_LATER && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupViewControllers
{
    NSArray *vcNameArr = @[@"School",@"Discovery",@"Message",@"Contacts",@"Mine"];
    NSArray *titleArray = @[@"校园", @"发现" , @"消息" , @"联系人" , @"我"];
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
    //    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    //    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    //    UIImage *finishedImage = [UIImage imageNamed:@"img_nofull@2x.png"];
    //    UIImage *unfinishedImage = [UIImage imageNamed:@"img_nofull@2x.png"];
    
    //    NSArray *vcNameArr = @[@"tongchengyaoyue",@"quanchengshangjia",@"tuangou",@"wode",@"gengduo"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        UIImage *finishedImage = [UIImage imageNamed:[NSString stringWithFormat:@"labbar_btn_choosed_%i",
                                                      index+1]];
        UIImage *unfinishedImage = [UIImage imageNamed:[NSString stringWithFormat:@"labbar_btn_%i",
                                                        index+1]];
        
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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

@end

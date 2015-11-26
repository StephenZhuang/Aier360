//
//  ZXAboutViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/16.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAboutViewController.h"
#import "ZXPrivacyViewController.h"
#import <VTAcknowledgementsViewController/VTAcknowledgementsViewController.h>
#import <StoreKit/StoreKit.h>
#import "ZXWelcomeView.h"

@interface ZXAboutViewController ()<SKStoreProductViewControllerDelegate>
@property (nonatomic , weak) IBOutlet UILabel *viersionLabel;
@end

@implementation ZXAboutViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于爱儿邦";
    
    [self.dataArray addObjectsFromArray:@[@"给我评分",@"功能介绍"]];
    
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    
    [_viersionLabel setText:[NSString stringWithFormat:@"v%@", info[@"CFBundleShortVersionString"]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)addHeader{}
- (void)addFooter{}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self evaluate];
    } else if (indexPath.row == 1) {
        ZXWelcomeView *welcomeView = [[ZXWelcomeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.navigationController.view addSubview:welcomeView];
        [UIView transitionWithView:self.navigationController.view duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            
        } completion:^(BOOL finished) {
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)privacyAction:(id)sender
{
    ZXPrivacyViewController *vc = [ZXPrivacyViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)openSourceAction:(id)sender
{
    VTAcknowledgementsViewController *viewController = [VTAcknowledgementsViewController acknowledgementsViewController];
    viewController.headerText = NSLocalizedString(@"We expressed our appreciation to the open source components.", nil); // optional
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)evaluate{
    
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier : @"954171545"} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
                 
             }
              ];
         }
     }];
}

//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end

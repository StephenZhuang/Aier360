//
//  ZXSchoolMenuViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolMenuViewController.h"
#import "ZXMenuCell.h"
#import "ZXAccount+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXProvinceViewController.h"
#import "ZXSchollDynamicViewController.h"
#import "APService.h"
#import "AppDelegate.h"
#import "ChatDemoUIDefine.h"
#import "ZXTeacherGracefulViewController.h"
#import "ZXSchoolSummaryViewController.h"
#import "ZXSchoolImageViewController.h"
#import "ZXNotificationHelper.h"
#import "ZXPersonalDynamic+ZXclient.h"
#import "ZXDynamicMessage+ZXclient.h"
#import "ZXBlankSchoolViewController.h"
#import "ZXBigImageViewController.h"
#import "MagicalMacro.h"
#import "ZXTeachersViewController.h"
#import "ZXClassListViewController.h"
#import "ZXAnnouncementViewController.h"
#import "ZXSchoolMenuCollectionViewCell.h"
#import "ZXSchoolMenuCollectionReusableView.h"
#import "NSManagedObject+ZXRecord.h"
#import "ZXMessageTaskViewController.h"
#import "ZXSchoolMenuHeader.h"

@implementation ZXSchoolMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSuccess:) name:@"changeSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editSchool) name:changeSchoolNotification object:nil];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"切换学校" style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    self.navigationItem.rightBarButtonItem = item;
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"获取身份" toView:self.view];
    [ZXAccount getLoginStatusWithUid:[ZXUtils sharedInstance].user.uid block:^(ZXAccount *account , NSError *error) {
        [hud hide:YES];
        if (!error) {
            [ZXUtils sharedInstance].account = account;
            NSDictionary *dic = [account keyValues];
            [GVUserDefaults standardUserDefaults].account = dic;
            if (account.logonStatus == 1) {
                ZXBlankSchoolViewController *vc = [ZXBlankSchoolViewController viewControllerFromStoryboard];
                vc.view.frame = self.view.bounds;
                [self.view addSubview:vc.view];
            } else if (account.logonStatus == 2) {
                [self performSegueWithIdentifier:@"change" sender:nil];
            }
            
            
            [self configureDataArray];
            [self checkReawrd];
            [self configureHeader];
            
            [self setTags:account.tags];
        }
    }];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self
                                        delegateQueue:nil];
    
    
}

- (void)editSchool
{
    [self configureHeader];
}

- (void)configureHeader
{
    __weak __typeof(&*self)weakSelf = self;
    ZXSchoolMenuHeader *header = (ZXSchoolMenuHeader *)[[[NSBundle mainBundle] loadNibNamed:@"ZXSchoolMenuHeader" owner:self options:nil] firstObject];
    [header setData:self.dataArray];
    header.hasReward = self.hasReward;
    [header configureUIWithSchool:[ZXUtils sharedInstance].currentSchool];
    header.SelectedIndexBlock = ^(NSInteger index) {
        NSString *string = weakSelf.dataArray[index];
        if ([string isEqualToString:@"校园动态"]) {
            ZXSchollDynamicViewController *vc = [ZXSchollDynamicViewController viewControllerFromStoryboard];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"校园通知"]) {
            ZXAnnouncementViewController *vc = [ZXAnnouncementViewController viewControllerFromStoryboard];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"校园简介"]) {
            ZXSchoolSummaryViewController *vc = [ZXSchoolSummaryViewController viewControllerFromStoryboard];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"教师风采"]) {
            ZXTeacherGracefulViewController *vc = [ZXTeacherGracefulViewController viewControllerFromStoryboard];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"打卡记录"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ICCard" bundle:nil];
            NSString *vcName = @"ZXCardHistoryMenuViewController";
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:vcName];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"我的IC卡"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ICCard" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZXMyCardViewController"];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"教师列表"]) {
            ZXTeachersViewController *vc = [ZXTeachersViewController viewControllerFromStoryboard];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"短信账户"]) {
            ZXMessageTaskViewController *vc = [ZXMessageTaskViewController viewControllerFromStoryboard];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"信息监控"]) {
            
        }
        else {
            ZXClassListViewController *vc = [ZXClassListViewController viewControllerFromStoryboard];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    self.tableView.tableHeaderView = header;
}

- (void)setTags:(NSString *)tags
{
    NSArray *arr = [tags componentsSeparatedByString:@","];
    NSSet *set = [NSSet setWithArray:arr];
    [APService setTags:[APService filterValidTags:set] alias:[ZXUtils sharedInstance].user.account callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logSet:(NSSet *)dic {
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

- (void)didLoginFromOtherDevice
{
    if ([GVUserDefaults standardUserDefaults].isLogin) {
        [self logout];
    }
}

- (void)logout
{
    [ZXPersonalDynamic clearDynamicWhenLogout];
    [GVUserDefaults standardUserDefaults].isLogin = NO;
    [GVUserDefaults standardUserDefaults].account = nil;
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.25 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void) {
        
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.window.rootViewController = nav;
    } completion:^(BOOL isFinished) {
        if (isFinished) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的账号已在别处登录" message:@"您已被迫下线" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        if (error) {
            
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    } onQueue:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setHidden:NO];
    
    NSArray *arrary = [ZXPersonalDynamic where:@{@"sid":@([ZXUtils sharedInstance].currentSchool.sid),@"isTemp":@NO} order:@{@"cdate" : @"DESC"} limit:@(1)];
    NSString *time = @"";
    if (arrary.count > 0) {
        ZXPersonalDynamic *dynamic = [arrary firstObject];
        time = dynamic.cdate;
    }
    [ZXPersonalDynamic checkNewSchoolDynamicWithUid:GLOBAL_UID time:time sid:[ZXUtils sharedInstance].currentSchool.sid block:^(BOOL hasNew, NSError *error) {
        if (hasNew != hasNewDynamic) {
            hasNewDynamic = hasNew;
            [self configureHeader];
        }
    }];
    
    [self checkReawrd];
}

- (void)checkReawrd
{
    [ZXAccount checkHasRewardWithSid:[ZXUtils sharedInstance].currentSchool.sid block:^(BOOL hasReward, NSError *error) {
        self.hasReward = hasReward;
        [self configureHeader];
    }];
}

- (void)changeSuccess:(NSNotification *)notification
{
    [self configureDataArray];
    [self configureHeader];
}

- (IBAction)moreAction:(id)sender
{
    [self performSegueWithIdentifier:@"change" sender:sender];
}

- (void)configureDataArray
{
    self.dataArray = [[NSMutableArray alloc] initWithObjects:@"校园通知",@"打卡记录",@"我的IC卡", nil];
    
    NSArray *menuArray;
    ZXIdentity identity = [[ZXUtils sharedInstance] getHigherIdentity];

    if (identity == ZXIdentityParent) {
        menuArray = @[@"教工列表"];
    } else if (identity == ZXIdentityStaff) {
        menuArray = @[@"教工列表"];
    } else {
        menuArray = @[@"教师列表",@"学生列表"];
    }
    
    [self.dataArray insertObjects:menuArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, menuArray.count)]];
    if (identity == ZXIdentitySchoolMaster) {
        [self.dataArray insertObject:@"信息监控" atIndex:1];
        [self.dataArray insertObject:@"短信账户" atIndex:1];
    }
}

- (IBAction)joinSchool_teacher:(id)sender
{
    ZXBigImageViewController *vc = [ZXBigImageViewController viewControllerFromStoryboard];
    vc.title = @"教师";
    vc.imageName = @"joinschool_teacher";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)joinSchool_parents:(id)sender
{
    ZXBigImageViewController *vc = [ZXBigImageViewController viewControllerFromStoryboard];
    vc.title = @"家长";
    vc.imageName = @"joinschool_parents";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:changeSchoolNotification object:nil];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - tbaleview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

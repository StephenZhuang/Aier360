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
#import "NSManagedObject+ZXRecord.h"
#import "ZXMessageTaskViewController.h"
#import "ZXSchoolMenuHeader.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "ZXPersonalDyanmicDetailViewController.h"
#import "ZXSchoolDynamicCell.h"
#import "UIViewController+ZXPhotoBrowser.h"
#import "ZXMyProfileViewController.h"
#import "ZXUserProfileViewController.h"
#import "ZXSquareDynamicsViewController.h"
#import "ZXManagedUser.h"
#import "ZXClassFilterViewController.h"
#import <NSArray+ObjectiveSugar.h>
#import "ZXReleaseSchoolDynamicViewController.h"
#import "ZXSchoolProfileViewController.h"

@implementation ZXSchoolMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSuccess:) name:@"changeSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editSchool) name:changeSchoolNotification object:nil];
    
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
            
            
            [self configureItemArray];
            [self checkReawrd];
            [self configureHeader];
            
            [self setTags:account.tags];
            [self loadFirstCache];
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
    [header setData:self.itemArray];
    header.hasReward = self.hasReward;
    [header configureUIWithSchool:[ZXUtils sharedInstance].currentSchool];
    header.SelectedIndexBlock = ^(NSInteger index) {
        NSString *string = weakSelf.itemArray[index];
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
    header.schollImageBlock = ^(void) {
        ZXSchoolImageViewController *vc = [ZXSchoolImageViewController viewControllerFromStoryboard];
        [weakSelf.navigationController pushViewController:vc animated:YES];
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
    [self configureItemArray];
    [self configureHeader];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self loadData];
}

- (void)configureItemArray
{
    self.itemArray = [[NSMutableArray alloc] initWithObjects:@"校园通知",@"打卡记录",@"我的IC卡", nil];
    
    NSArray *menuArray;
    ZXIdentity identity = [[ZXUtils sharedInstance] getHigherIdentity];

    if (identity == ZXIdentityParent) {
        menuArray = @[@"教工列表"];
    } else if (identity == ZXIdentityStaff) {
        menuArray = @[@"教工列表"];
    } else {
        menuArray = @[@"教师列表",@"学生列表"];
    }
    
    [self.itemArray insertObjects:menuArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, menuArray.count)]];
    if (identity == ZXIdentitySchoolMaster) {
        [self.itemArray insertObject:@"信息监控" atIndex:1];
        [self.itemArray insertObject:@"短信账户" atIndex:1];
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

- (IBAction)filterAction:(id)sender
{
    UINavigationController *nav = [[UIStoryboard storyboardWithName:@"School" bundle:nil] instantiateViewControllerWithIdentifier:@"FilterNav"];
    ZXClassFilterViewController *vc = [nav.viewControllers firstObject];
    vc.selectClassBlock = ^(void) {
        [[ZXPersonalDynamic where:@{@"sid":@([ZXUtils sharedInstance].currentSchool.sid),@"type":@(2),@"isTemp":@NO}] each:^(ZXPersonalDynamic *dynamic) {
            [dynamic delete];
        }];
        
        NSString *key = [NSString stringWithFormat:@"classVersion%@",@(GLOBAL_UID)];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        
        [self.tableView headerBeginRefreshing];
    };
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)addClassDynamicAction:(id)sender
{
    ZXReleaseSchoolDynamicViewController *vc = [ZXReleaseSchoolDynamicViewController viewControllerFromStoryboard];
    vc.isClassDynamic = YES;
    vc.addSuccess = ^(void) {
        [self.tableView headerBeginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)schoolMenuAction:(id)sender
{
    ZXSchoolProfileViewController *vc = [ZXSchoolProfileViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
    return [tableView fd_heightForCellWithIdentifier:@"ZXSchoolDynamicCell" cacheByIndexPath:indexPath configuration:^(ZXSchoolDynamicCell *cell) {
        [cell configureWithDynamic:dynamic];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(&*self)weakSelf = self;
    ZXPersonalDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
    ZXSchoolDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXSchoolDynamicCell"];
    [cell configureWithDynamic:dynamic];
    cell.imageClickBlock = ^(NSInteger index) {
        NSArray *array = [dynamic.img componentsSeparatedByString:@","];
        [weakSelf browseImage:array index:index];
    };
    cell.headClickBlock = ^(void) {
        ZXManagedUser *user = dynamic.user;
        if (user.uid == GLOBAL_UID) {
            ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
            vc.uid = user.uid;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    cell.squareLabelBlock = ^(NSInteger oslid) {
        ZXSquareDynamicsViewController *vc = [ZXSquareDynamicsViewController viewControllerFromStoryboard];
        vc.oslid = oslid;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.favButton.tag = indexPath.section;
    cell.commentButton.tag = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:indexPath.section];
    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
    vc.did = dynamc.did;
    vc.type = 1;
    vc.dynamic = dynamc;
    vc.isCachedDynamic = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)favAction:(UIButton *)sender
{
    if (sender.selected) {
        [MBProgressHUD showText:@"您已经喜欢过了~" toView:self.view];
    } else {
        ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:sender.tag];
        dynamc.hasParise = 1;
        dynamc.pcount++;
        [dynamc save];
        sender.selected = YES;
        [ZXPersonalDynamic praiseDynamicWithUid:GLOBAL_UID did:dynamc.did type:1 block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                dynamc.hasParise = 0;
                dynamc.pcount = MAX(0, dynamc.pcount-1);
                [dynamc save];
                sender.selected = NO;;
                [MBProgressHUD showText:errorInfo toView:self.view];
            }
        }];
    }
}

- (IBAction)commentAction:(UIButton *)sender
{
    ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:sender.tag];
    
    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
    vc.did = dynamc.did;
    vc.type = 1;
    vc.dynamic = dynamc;
    vc.isCachedDynamic = YES;
    vc.needShowComment = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - loaddata
- (void)addFooter
{
    [self.tableView addFooterWithCallback:^(void){
        page++;
        if (hasCache) {
            [self loadCaChe];
        } else {
            [self loadMore];
        }
    }];
}

- (void)addHeader
{
    [self.tableView addHeaderWithCallback:^(void) {
        page = 1;
        [self.tableView setFooterHidden:NO];
        
        [self loadData];
    }];
    //    [self.tableView headerBeginRefreshing];
}

- (void)loadData
{
    NSString *time = @"";
    if (self.dataArray.count > 0) {
        ZXPersonalDynamic *dynamic = [[ZXPersonalDynamic where:@{@"sid":@([ZXUtils sharedInstance].currentSchool.sid),@"type":@(2),@"isTemp":@NO} order:@{@"cdate":@"ASC"} limit:@1] firstObject];
        time = dynamic.cdate;
    }
    [ZXPersonalDynamic getLatestClassDynamicWithUid:GLOBAL_UID time:time pageSize:pageCount sid:[ZXUtils sharedInstance].currentSchool.sid cid:[GVUserDefaults standardUserDefaults].selectedCid block:^(NSArray *array, NSError *error) {
        hasCache = YES;
        [self loadCaChe];
        [self.tableView headerEndRefreshing];
    }];
}

- (void)loadMore
{
    NSString *time = @"";
    if (self.dataArray.count > 0) {
        ZXPersonalDynamic *dynamic = [self.dataArray lastObject];
        time = dynamic.cdate;
    }
    
    [ZXPersonalDynamic getOlderClassDynamicWithUid:GLOBAL_UID time:time pageSize:pageCount sid:[ZXUtils sharedInstance].currentSchool.sid cid:[GVUserDefaults standardUserDefaults].selectedCid block:^(NSArray *array, NSError *error) {
        [self.dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
        if (array.count < pageCount) {
            hasMore = NO;
            [self.tableView setFooterHidden:YES];
        }
    }];
}

- (void)loadCaChe
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *time = @"";
        if (self.dataArray.count > 0) {
            ZXPersonalDynamic *dynamic = [self.dataArray lastObject];
            time = dynamic.cdate;
        }
        NSPredicate *predicate;
        if (page == 1) {
            predicate = [NSPredicate predicateWithFormat:@"(sid == %@) AND (isTemp == %@) AND (type == %@)",@([ZXUtils sharedInstance].currentSchool.sid) ,@NO,@(2)];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"(sid == %@) AND (cdate < %@) AND (isTemp == %@) AND (type == %@)",@([ZXUtils sharedInstance].currentSchool.sid), time,@NO,@(2)];
        }
        NSArray *array = [ZXPersonalDynamic where:predicate order:@{@"cdate" : @"DESC"} limit:@(pageCount)];
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
            [self configureBlankView];
            
            if (array.count < pageCount) {
                hasCache = NO;
            }
        });
    });
}

- (void)loadFirstCache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSArray *arrary = [ZXPersonalDynamic where:@{@"sid":@([ZXUtils sharedInstance].currentSchool.sid),@"type":@(2),@"isTemp":@NO} order:@{@"cdate" : @"DESC"} limit:@(pageCount)];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [self.dataArray addObjectsFromArray:arrary];
            [self.tableView reloadData];
            [self.tableView headerBeginRefreshing];
            if (arrary.count < pageCount) {
                hasCache = NO;
            }
        });
    });
}
@end

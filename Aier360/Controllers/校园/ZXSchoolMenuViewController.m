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

@implementation ZXSchoolMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.schoolImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.schoolImageView.layer.masksToBounds = YES;
    [self.tableView setSeparatorColor:[UIColor colorWithRed:237/255.0 green:235/255.0 blue:229/255.0 alpha:1.0]];
    
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
            
            
            [self configureUIWithSchool:[ZXUtils sharedInstance].currentSchool];
            [self.tableView reloadData];
            
            [self setTags:account.tags];
            [self getUnreadMessageNum];
        }
    }];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self
                                        delegateQueue:nil];
    [self.tableView setExtrueLineHidden];
}

- (void)getUnreadMessageNum
{
    [ZXDynamicMessage getNewSchoolDynamicMessageWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid block:^(NSInteger newMessageNum, NSError *error) {
        unreadNum = newMessageNum;
        [self.tableView reloadData];
    }];
}

- (void)editSchool
{
    [self configureUIWithSchool:[ZXUtils sharedInstance].currentSchool];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的账号已在别处登录" message:@"您已被迫下线" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self logout];
}

- (void)logout
{
    [ZXPersonalDynamic clearDynamicWhenLogout];
    [GVUserDefaults standardUserDefaults].isLogin = NO;
//    [GVUserDefaults standardUserDefaults].user = nil;
    [GVUserDefaults standardUserDefaults].account = nil;
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.25 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void) {
        
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.window.rootViewController = nav;
    } completion:^(BOOL isFinished) {
        if (isFinished) {
        }
    }];
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
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
    if ([ZXUtils sharedInstance].currentSchool) {
        [self getUnreadMessageNum];
    }
}

- (void)changeSuccess:(NSNotification *)notification
{
    [self configureUIWithSchool:[ZXUtils sharedInstance].currentSchool];
    [self.tableView reloadData];
}

- (IBAction)moreAction:(id)sender
{
    [self performSegueWithIdentifier:@"change" sender:sender];
}

#pragma mark- tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ZXMenuCell"];
    if (indexPath.section == 0) {
        [cell.logoImage setImage:[UIImage imageNamed:@"school_ic_dynamic"]];
        [cell.titleLabel setText:@"校园动态"];
        if (unreadNum > 0) {
            [cell.hasNewLabel setText:[NSString stringWithFormat:@"%@",@(unreadNum)]];
            [cell.hasNewLabel setHidden:NO];
        } else {
            [cell.hasNewLabel setHidden:YES];
        }
    } else if (indexPath.section == 1) {
        [cell.hasNewLabel setHidden:YES];
        if (indexPath.row == 0) {
            [cell.logoImage setImage:[UIImage imageNamed:@"school_ic_info"]];
            [cell.titleLabel setText:@"校园简介"];
        } else {
            [cell.logoImage setImage:[UIImage imageNamed:@"school_ic_teacher"]];
            [cell.titleLabel setText:@"教师风采"];
        }
    } else {
        [cell.hasNewLabel setHidden:YES];
        if (indexPath.row == 0) {
            [cell.logoImage setImage:[UIImage imageNamed:@"school_ic_card"]];
            [cell.titleLabel setText:@"打卡记录"];
        } else {
            [cell.logoImage setImage:[UIImage imageNamed:@"我的IC卡"]];
            [cell.titleLabel setText:@"我的IC卡"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXSchollDynamicViewController *vc = [ZXSchollDynamicViewController viewControllerFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ZXSchoolSummaryViewController *vc = [ZXSchoolSummaryViewController viewControllerFromStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            ZXTeacherGracefulViewController *vc = [ZXTeacherGracefulViewController viewControllerFromStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ICCard" bundle:nil];
        if (indexPath.row == 0) {
            
            NSString *vcName = @"";
            ZXIdentity identity = [[ZXUtils sharedInstance] getHigherIdentity];
            switch (identity) {
                case ZXIdentitySchoolMaster:
                    vcName = @"ZXCardHistoryMenuViewController";
                    break;
                case ZXIdentityClassMaster:
                    vcName = @"ZXCardHistoryMenuViewController";
                    break;
                case ZXIdentityTeacher:
                    vcName = @"ZXMonthHistoryViewController";
                    break;
                case ZXIdentityParent:
                    vcName = @"ZXParentHistoryViewController";
                    break;
                case ZXIdentityNone:
                    vcName = @"ZXMonthHistoryViewController";
                    break;
                case ZXIdentityStaff:
                    vcName = @"ZXMonthHistoryViewController";
                    break;
                case ZXIdentityUnchoosesd:
                    vcName = @"ZXMonthHistoryViewController";
                    break;
                default:
                    vcName = @"ZXMonthHistoryViewController";
                    break;
            }
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:vcName];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZXMyCardViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat ImageWidth = SCREEN_WIDTH;
    CGFloat ImageHeight = 215;
    if (offsetY < 0) {
        CGFloat factor = ((ABS(offsetY)+ImageHeight)*ImageWidth)/ImageHeight;
        CGRect f = CGRectMake(-(factor-ImageWidth)/2, offsetY, factor, ImageHeight+ABS(offsetY));
        self.schoolImageView.layer.frame = f;
    } else {
        CGFloat ImageWidth = self.schoolImageView.frame.size.width;
        CGFloat ImageHeight = self.schoolImageView.frame.size.height;
        CGRect f = CGRectMake(0, 0, ImageWidth, ImageHeight);
        self.schoolImageView.layer.frame = f;
        
    }
}

- (UIImage *)blureImage:(UIImage *)originImage withInputRadius:(CGFloat)inputRadius
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:originImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(inputRadius) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = CGRectInset(filter.outputImage.extent, 10, 10);
    CGImageRef outImage = [context createCGImage: result fromRect:extent];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}

- (void)configureUIWithSchool:(ZXSchool *)school
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[[ZXImageUrlHelper imageUrlForSchoolImage:school.img].absoluteString stringByReplacingOccurrencesOfString:@"small" withString:@"origin"]] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
    
        if (!image) {
            image = [UIImage imageNamed:@"mine_profile_bg"];
        }
//        UIImage *blurImage = [self blureImage:image withInputRadius:5];
//        if (blurImage) {
            [self.schoolImageView setImage:image];
//        }
    }];
    
    [self.schoolNameLabel setText:school.name];
    [self.imgNumButton setTitle:[NSString stringWithFormat:@"%@",@(school.num_img)] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSchoolImg)];
    [self.schoolImageView addGestureRecognizer:tap];
    self.schoolImageView.userInteractionEnabled = YES;
}

- (void)gotoSchoolImg
{
    ZXSchoolImageViewController *vc = [ZXSchoolImageViewController viewControllerFromStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)joinSchool:(id)sender
{
    ZXBigImageViewController *vc = [ZXBigImageViewController viewControllerFromStoryboard];
    vc.title = @"如何加入班级";
    vc.imageName = @"joinSchool";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:changeSchoolNotification object:nil];
}
@end

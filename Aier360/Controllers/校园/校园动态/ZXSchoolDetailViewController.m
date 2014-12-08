//
//  ZXSchoolDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/4.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolDetailViewController.h"
#import "ZXSchoolSummaryViewController.h"
#import "ZXTeacherGracefulViewController.h"
#import "ZXJoinChooseIdenty.h"

@interface ZXSchoolDetailViewController ()

@end

@implementation ZXSchoolDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
    ZXAppStateInfo *stateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXSchool schoolInfoWithSid:stateInfo.sid block:^(ZXSchool *school, ZXSchoolDetail *schoolDetail, NSArray *array, NSError *error) {
        _school = school;
        _schoolDetail = schoolDetail;
        _teacherArray = array;
        self.title = _school.name;
        [_logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSchoolLogo:_school.slogo]];
        [_memberLabel setText:[NSString stringWithFormat:@"成员:%i",_school.memberNum]];
        [_addressLabel setText:_school.address];
    }];
    
    UIBarButtonItem *message = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"school_message"] style:UIBarButtonItemStyleBordered target:self action:@selector(goToMessage)];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItems = @[more,message];
}

- (void)goToMessage
{
    
}

- (void)moreAction
{
    ZXJoinChooseIdenty *vc = [[UIStoryboard storyboardWithName:@"School" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXJoinChooseIdenty"];
    vc.school = _school;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"kong"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:26 green:30 blue:33]];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 64) {
        [self.navigationController.navigationBar setHidden:YES];
    } else {
        [self.navigationController.navigationBar setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"summary"]) {
        ZXSchoolSummaryViewController *vc = segue.destinationViewController;
        vc.schoolDetail = _schoolDetail;
    } else if ([segue.identifier isEqualToString:@"teacher"]) {
        ZXTeacherGracefulViewController *vc = segue.destinationViewController;
        vc.dataArray = [_teacherArray mutableCopy];
    }
}


@end

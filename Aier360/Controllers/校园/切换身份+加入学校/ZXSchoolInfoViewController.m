//
//  ZXSchoolInfoViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/14.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolInfoViewController.h"
#import "ZXJoinChooseIdenty.h"


@interface ZXSchoolInfoViewController ()
@property (nonatomic , weak) IBOutlet UIImageView *logoImage;
@property (nonatomic , weak) IBOutlet UILabel *memberLabel;
@property (nonatomic , weak) IBOutlet UILabel *addressLabel;
@property (nonatomic , weak) IBOutlet TopBarView *topbarView;
@property (nonatomic , strong) NSArray *topbarArray;
@end

@implementation ZXSchoolInfoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _school.name;
    _logoImage.layer.cornerRadius = 32;
    _logoImage.layer.masksToBounds = YES;
    _logoImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _logoImage.layer.borderWidth = 2;
    [_logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSchoolLogo:_school.slogo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [_memberLabel setText:[NSString stringWithFormat:@"成员:%i",_school.memberNum]];
    [_addressLabel setText:_school.address];
    _topbarArray = @[@"校园动态",@"校园简介",@"教师风采"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"kong"] forBarMetrics:UIBarMetricsDefault];
    if(IOS8_OR_LATER && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [self.navigationController.navigationBar setTranslucent:YES];
    }
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:26 green:30 blue:33]];
    if(IOS8_OR_LATER && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [self.navigationController.navigationBar setTranslucent:NO];
    }
}

#pragma -mark topbarview delegate
- (NSInteger)numOfItems
{
    return _topbarArray.count;
}

- (NSString *)topBarView:(TopBarView *)topBarView nameForItem:(NSInteger)item
{
    return _topbarArray[item];
}

- (NSInteger)defaultSelectedItem
{
    return 0;
}

- (void)selectItemAtIndex:(NSInteger)index
{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ZXJoinChooseIdenty *vc = segue.destinationViewController;
    vc.school = _school;
}
@end

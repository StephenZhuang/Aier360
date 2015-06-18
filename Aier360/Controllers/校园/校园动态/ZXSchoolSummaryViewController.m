//
//  ZXSchoolSummaryViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/4.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolSummaryViewController.h"
#import "ZXCustomTextFieldViewController.h"

@interface ZXSchoolSummaryViewController ()

@end

@implementation ZXSchoolSummaryViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSchoolSummaryViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"校园简介";
    
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
        self.navigationItem.rightBarButtonItem = item;
    }
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)edit:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
//        NSDictionary *dic = [_schoolDetail keyValues];
//        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        [ZXSchool updateSchoolInfoWithSid:_schoolDetail.sid schools:[NSString stringWithFormat:@"{\"sid\":%i}",_schoolDetail.sid] schoolInfoDetails:string block:^(ZXBaseModel *baseModel, NSError *error) {
//            if (baseModel && baseModel.s) {
//
//            }
//        }];
    }
}

- (void)configureUI
{
    ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
    [_infoLabel setText:school.desinfo];
    [_nameLabel setText:school.name];
    [_telButton setTitle:school.phone forState:UIControlStateNormal];
    [_addressLabel setText:school.address];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ZXSchoolSummaryViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/4.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolSummaryViewController.h"
#import "ZXCustomTextFieldViewController.h"
#import "ZXEditSummaryViewController.h"

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

- (void)edit:(id)sender
{
    ZXEditSummaryViewController *vc = [ZXEditSummaryViewController viewControllerFromStoryboard];
    vc.school = [ZXUtils sharedInstance].currentSchool;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configureUI
{
    ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
    [_infoLabel setText:school.desinfo];
    [_nameLabel setText:school.name];
    [_telButton setTitle:school.phone forState:UIControlStateNormal];
    [_addressLabel setText:school.address];
}

- (IBAction)phoneAction:(UIButton *)sender
{
    ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
    NSString *phone = school.phone;
    
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel://%@",phone];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    [self.view addSubview:callWebview];
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

//
//  ZXUnactiveTeacherViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/17.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUnactiveTeacherViewController.h"
#import "ZXMenuCell.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXTeacherInfoViewController.h"
#import "ZXSendMessageToUnactiveViewController.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXUnactiveTeacherViewController ()

@end

@implementation ZXUnactiveTeacherViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Teachers" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXUnactiveTeacherViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"未激活";
}

- (void)addFooter{}

- (void)loadData
{
    [ZXTeacherNew getUnactiveTeacherWithSid:[ZXUtils sharedInstance].currentSchool.sid uid:GLOBAL_UID block:^(NSArray *array, BOOL hasSentMessage, NSString *messageStr, NSError *error) {
        self.hasSentMessage = hasSentMessage;
        self.messageStr = messageStr;
        [self configureArrayWithNoFooter:array];
        [self configureHeader];
    }];
}

- (void)configureHeader
{
    [self.headerLabel setText:[NSString stringWithFormat:@"还有%@位教师没有登录激活，您可以发送免费短信提醒他们激活！",@(self.dataArray.count)]];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ZXTeacherNew *teacher = [self.dataArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:teacher.tname];

    [cell.logoImage setImage:[UIImage imageNamed:@"contact_sexnone"]];
    [cell.hasNewLabel setText:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXTeacherNew *teacher = [self.dataArray objectAtIndex:indexPath.row];
    ZXTeacherInfoViewController *vc = [ZXTeacherInfoViewController viewControllerFromStoryboard];
    vc.teacher = teacher;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)sendMessageAction:(id)sender
{
    if (!self.hasSentMessage) {
        if (self.dataArray.count > 0) {            
            ZXSendMessageToUnactiveViewController *vc = [ZXSendMessageToUnactiveViewController viewControllerFromStoryboard];
            vc.content = self.messageStr;
            vc.sendSuccess = ^(void) {
                self.hasSentMessage = YES;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [MBProgressHUD showText:@"今天已发送过提醒短信，明天再来吧！" toView:self.view];
    }
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

//
//  ZXUnactiveParentViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/17.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUnactiveParentViewController.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXMenuCell.h"
#import "ZXParent.h"
#import "ZXStudent.h"
#import "ZXStudentInfoViewController.h"
#import "ZXSendMessageToUnactiveViewController.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXUnactiveParentViewController ()

@end

@implementation ZXUnactiveParentViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Teachers" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXUnactiveParentViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"未激活";
}

- (void)addFooter{}

- (void)loadData
{
    [ZXTeacherNew getUnacitveParentWithSid:[ZXUtils sharedInstance].currentSchool.sid uid:GLOBAL_UID cid:self.cid block:^(NSArray *array, BOOL hasSentMessage, NSString *messageStr, NSError *error) {
        self.hasSentMessage = hasSentMessage;
        self.messageStr = messageStr;
        [self configureArrayWithNoFooter:array];
        [self configureHeader];
    }];
}

- (void)configureHeader
{
    [self.headerLabel setText:[NSString stringWithFormat:@"还有%@位家长没有登录激活，您可以发送免费短信提醒他们激活！",@(self.dataArray.count)]];
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
    ZXParent *parent = [self.dataArray objectAtIndex:indexPath.row];
    [cell.titleLabel setText:parent.pname];
    
    [cell.logoImage setImage:[UIImage imageNamed:@"contact_sexnone"]];
    [cell.hasNewLabel setText:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXStudentInfoViewController *vc = [ZXStudentInfoViewController viewControllerFromStoryboard];
    ZXParent *parent = [self.dataArray objectAtIndex:indexPath.row];
    ZXStudent *student = [[ZXStudent alloc] init];
    student.sname = parent.name_student;
    student.csid = parent.csid;
    vc.student = student;
    vc.cid = self.cid;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)sendMessageAction:(id)sender
{
    if (!self.hasSentMessage) {
        if (self.dataArray.count > 0) {            
            ZXSendMessageToUnactiveViewController *vc = [ZXSendMessageToUnactiveViewController viewControllerFromStoryboard];
            vc.content = self.messageStr;
            vc.cid = self.cid;
            vc.sendSuccess = ^(void) {
                self.hasSentMessage = YES;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [MBProgressHUD showText:@"今天已发送过提醒短信，明天再来发送吧！" toView:self.view];
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

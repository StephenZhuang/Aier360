//
//  ZXMyCardViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMyCardViewController.h"
#import "ZXICCard+ZXclient.h"
#import "ZXICCardTableViewCell.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXMyCardViewController ()

@end

@implementation ZXMyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的IC卡";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)loadData
{
    [ZXICCard getCardListWithUid:GLOBAL_UID sid:[ZXUtils sharedInstance].currentSchool.sid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

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
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXICCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXICCardTableViewCell"];
    ZXICCard *card = [self.dataArray objectAtIndex:indexPath.section];
    [cell configureCellWithCard:card];
    cell.actionButton.tag = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)lostAction:(UIButton *)sender
{
    ZXICCard *card = [self.dataArray objectAtIndex:sender.tag];
    if (card.state != 20) {        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"挂失后此卡将成为一张废卡，确定挂失?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.tag = sender.tag;
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
        [ZXICCard getCardMessageCodeWithUid:GLOBAL_UID block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"短信验证码已发送到手机%@上",[ZXUtils sharedInstance].user.account] message:@"请输入验证码完成挂失" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.tag = actionSheet.tag;
                [alert show];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"提交中" toView:self.view];
        ZXSchool *school = [ZXUtils sharedInstance].currentSchool;
        ZXICCard *card = [self.dataArray objectAtIndex:alertView.tag];
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSString *message = [tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [ZXICCard changeICCardStateWithSid:school.sid icid:card.icid state:20 uid:GLOBAL_UID message:message block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@"挂失成功"];
                card.state = 20;
                [self.tableView reloadData];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
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
}


@end

//
//  ZXAddAnnouncementViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddAnnouncementViewController.h"
#import "ZXAnnouncement+ZXclient.h"

@interface ZXAddAnnouncementViewController ()

@end

@implementation ZXAddAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布公告";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    [_contentTextView setPlaceholder:@"发布内容"];
    _receiver = @"全体教职工";
    _receiverArray = [[NSMutableArray alloc] init];
    if ([ZXUtils sharedInstance].identity == ZXIdentitySchoolMaster) {
        [_receiverArray addObjectsFromArray:@[@"全体教职工",@"全体教职工和家长"]];
        ZXAppStateInfo *appstateinfo = [ZXUtils sharedInstance].currentAppStateInfo;
        [ZXAnnouncement getSmsCountWithSid:appstateinfo.sid cid:appstateinfo.cid sendType:1 block:^(NSInteger totalMessage , NSInteger mesCount, NSError *error) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"同时发送短信" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor],   NSFontAttributeName : [UIFont systemFontOfSize:14]}];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(剩余短信%i条,本次需消耗%i条。一条短信64字，超过64字将发送大于1条)",mesCount ,totalMessage] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:132 green:132 blue:134],   NSFontAttributeName : [UIFont systemFontOfSize:14]}];
            [string appendAttributedString:string2];
            [_tipLabel setAttributedText:string];
        }];
    } else if ([ZXUtils sharedInstance].identity == ZXIdentityClassMaster) {
        ZXAppStateInfo *appstateinfo = [ZXUtils sharedInstance].currentAppStateInfo;
        [ZXAnnouncement getSmsCountWithSid:appstateinfo.sid cid:appstateinfo.cid sendType:3 block:^(NSInteger totalMessage , NSInteger mesCount, NSError *error) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"同时发送短信" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor],   NSFontAttributeName : [UIFont systemFontOfSize:14]}];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(剩余短信%i条,本次需消耗%i条。一条短信64字，超过64字将发送大于1条)",mesCount ,totalMessage] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:132 green:132 blue:134],   NSFontAttributeName : [UIFont systemFontOfSize:14]}];
            [string appendAttributedString:string2];
            [_tipLabel setAttributedText:string];
        }];
    }
}

- (void)submit
{
    [self.view endEditing:YES];
}

- (IBAction)smsAction:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
}
#pragma -mark textfield delegate
- (void)textChanged:(NSNotification *)notification
{
    [_letterNumLabel setText:[NSString stringWithFormat:@"已经输入%i字",_contentTextView.text.length]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_contentTextView becomeFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([ZXUtils sharedInstance].identity == ZXIdentitySchoolMaster) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:@"发送对象"];
    [cell.detailTextLabel setText:_receiver];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.section == 1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"发送对象" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:_receiverArray[0],_receiverArray[1], nil];
        [actionSheet showInView:self.view];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2) {
        _receiver = _receiverArray[buttonIndex];
        [self.tableView reloadData];
        
        ZXAppStateInfo *appstateinfo = [ZXUtils sharedInstance].currentAppStateInfo;
        [ZXAnnouncement getSmsCountWithSid:appstateinfo.sid cid:appstateinfo.cid sendType:buttonIndex+1 block:^(NSInteger totalMessage , NSInteger mesCount, NSError *error) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"同时发送短信" attributes:@{NSForegroundColorAttributeName : [UIColor blackColor],   NSFontAttributeName : [UIFont systemFontOfSize:14]}];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(剩余短信%i条,本次需消耗%i条。一条短信64字，超过64字将发送大于1条)",mesCount ,totalMessage] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:132 green:132 blue:134],   NSFontAttributeName : [UIFont systemFontOfSize:14]}];
            [string appendAttributedString:string2];
            [_tipLabel setAttributedText:string];
        }];
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

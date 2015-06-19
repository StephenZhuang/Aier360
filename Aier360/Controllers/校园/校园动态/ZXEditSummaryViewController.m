//
//  ZXEditSummaryViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/18.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXEditSummaryViewController.h"
#import "ZXTextFieldCell.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXSchool+ZXclient.h"
#import "ZXValidateHelper.h"

@implementation ZXEditSummaryViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXEditSummaryViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"校园简介";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
    
    [_textView setText:_school.desinfo];
    _textView.placeholder = @"例如办园理念、餐饮情况、特色课程等让家长更了解您的园";
}

- (void)submit
{
    [self.view endEditing:YES];
    if (![ZXValidateHelper checkTel:_school.phone needsWarning:YES]) {
        return;
    }
    
    if (_school.name.length == 0 || _school.desinfo.length == 0 || _school.phone.length == 0 || _school.address.length == 0) {
        [MBProgressHUD showText:@"请填写完整" toView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [ZXSchool updateSchoolInfoWithSid:_school.sid desinfo:_school.desinfo phone:_school.phone address:_school.address block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [hud turnToSuccess:@""];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
    
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 7;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0) {
        [cell.nameLabel setText:@"学校名称"];
        [cell.textField setText:_school.name];
        [cell.textField setPlaceholder:@"请填写"];
    } else if (indexPath.row == 1) {
        [cell.nameLabel setText:@"联系电话"];
        [cell.textField setText:_school.phone];
        [cell.textField setPlaceholder:@"请填写"];
    } else {
        [cell.nameLabel setText:@"学校地址"];
        [cell.textField setText:_school.address];
        [cell.textField setPlaceholder:@"请填写详细地址，方便查找"];
    }
    cell.textField.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        _school.name = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else if (textField.tag == 1) {
        _school.phone = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        _school.address = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}
#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _school.desinfo = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end

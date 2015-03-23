//
//  ZXAddTeacherViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/13.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddTeacherViewController.h"
#import "ZXMenuCell.h"
#import "ZXAddTeacherCell.h"
#import "ZXContactHeader.h"
#import "ZXValidateHelper.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXTeacherNew+ZXclient.h"
#import "ZXClassMultiPickerViewController.h"

@implementation ZXAddTeacherViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加教工";
    [self.tableView registerClass:[ZXContactHeader class] forHeaderFooterViewReuseIdentifier:@"contactHeader"];
    
    [self initVar];
}

- (void)initVar
{
    phoneNum = @"";
    name = @"";
    classids = @"";
}

- (IBAction)selectPeopleAction:(id)sender
{
    ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
    nav.peoplePickerDelegate = self;
    if(IOS8_OR_LATER){
        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)doneAction:(id)sender
{
    [self.view endEditing:YES];
    
    if (![ZXValidateHelper checkTel:phoneNum]) {
        return;
    }
    
    if (name.length > 10) {
        [MBProgressHUD showError:@"姓名须在10字以内" toView:self.view];
        return;
    }
    
    if (phoneNum.length > 0 && name.length > 0 && sex) {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
        [ZXTeacherNew addTeacherWithSid:[ZXUtils sharedInstance].currentAppStateInfo.sid realname:name gid:_gid uid:GLOBAL_UID tid:[ZXUtils sharedInstance].currentAppStateInfo.tid phone:phoneNum sex:sex cids:classids block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@""];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
    } else {
        [MBProgressHUD showError:@"请将资料填写完整" toView:self.view];
    }
}

#pragma -mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZXContactHeader *contactHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"contactHeader"];
    return contactHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            ZXAddTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAddTeacherCell"];
            [cell.titleLabel setText:@"教工姓名"];
            [cell.textField setText:name];
            [cell.textField setPlaceholder:@"请输入教工姓名"];
            cell.textField.tag = 0;
            [cell.addressBookButton setHidden:YES];
            return cell;
        }
            break;
        case 1:
        {
            ZXAddTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAddTeacherCell"];
            [cell.titleLabel setText:@"手机号码"];
            [cell.textField setText:phoneNum];
            [cell.textField setPlaceholder:@"请输入手机号码"];
            cell.textField.tag = 1;
            [cell.addressBookButton setHidden:NO];
            return cell;
        }
            break;
        case 2:
        {
            ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            [cell.titleLabel setText:@"教工性别"];
            if (sex) {
                [cell.hasNewLabel setText:sex];
            } else {
                [cell.hasNewLabel setText:@"请选择教工性别"];
            }
            return cell;
        }
            break;
        default:
        {
            ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            [cell.titleLabel setText:@"所在班级"];
            if (classes.length > 0) {
                [cell.hasNewLabel setText:classes];
            } else {
                [cell.hasNewLabel setText:@"请选择教工所在班级"];
            }
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [self.view endEditing:YES];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [actionSheet showInView:self.view];
    } else if (indexPath.row == 3) {
        [self showClassList];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -mark
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (phone && [ZXValidateHelper checkTel:phoneNO]) {
        phoneNum = phoneNO;
        [self.tableView reloadData];
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (phone && [ZXValidateHelper checkTel:phoneNO]) {
        phoneNum = phoneNO;
        [self.tableView reloadData];
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma -mark
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        name = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else {
        phoneNum = textField.text;
    }
}

#pragma -mark actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        sex = @"男";
        [self.tableView reloadData];
    } else if (buttonIndex == 1) {
        sex = @"女";
        [self.tableView reloadData];
    }
}

#pragma -mark
- (void)showClassList
{
    ZXClassMultiPickerViewController *vc = [ZXClassMultiPickerViewController viewControllerFromStoryboard];
    vc.ClassPickBlock = ^(NSString *classNames , NSString *cids) {
        classes = classNames;
        classids = cids;
        [self.tableView reloadData];
    };
    vc.classids = classids;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

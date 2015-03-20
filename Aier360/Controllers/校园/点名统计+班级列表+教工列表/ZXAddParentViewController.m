//
//  ZXAddParentViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddParentViewController.h"
#import "ZXMenuCell.h"
#import "ZXAddTeacherCell.h"
#import "ZXContactHeader.h"
#import "ZXValidateHelper.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXStudent+ZXclient.h"
#import "ZXPopPicker.h"
#import "ZXCustomTextFieldViewController.h"

@implementation ZXAddParentViewController
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
    relation = @"";
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
    
    if (phoneNum.length > 0 && relation.length > 0 && sex) {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
        [ZXStudent addParentWithCsid:_csid tid:[ZXUtils sharedInstance].currentAppStateInfo.tid sid:[ZXUtils sharedInstance].currentAppStateInfo.sid phone:phoneNum relation:relation sex:sex block:^(BOOL success, NSString *errorInfo) {
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
    return 3;
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
            ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            [cell.titleLabel setText:@"家长身份"];
            if (relation.length > 0) {
                [cell.hasNewLabel setText:relation];
            } else {
                [cell.hasNewLabel setText:@"请选择家长身份"];
            }
            return cell;
        }
            break;
        case 1:
        {
            ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            [cell.titleLabel setText:@"家长性别"];
            if (sex) {
                [cell.hasNewLabel setText:sex];
            } else {
                [cell.hasNewLabel setText:@"请选择家长性别"];
            }
            return cell;
        }
            break;
        default:
        {
            
            ZXAddTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXAddTeacherCell"];
            [cell.titleLabel setText:@"手机号码"];
            [cell.textField setText:phoneNum];
            [cell.textField setPlaceholder:@"请输入手机号码"];
            [cell.addressBookButton setHidden:NO];
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self.view endEditing:YES];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [actionSheet showInView:self.view];
    } else if (indexPath.row == 0) {
        __weak __typeof(&*self)weakSelf = self;
        NSArray *contents = @[@"爸爸",@"妈妈",@"外公",@"外婆",@"爷爷",@"奶奶",@"自定义"];
        ZXPopPicker *popPicker = [[ZXPopPicker alloc] initWithTitle:@"家长列表" contents:contents];
        popPicker.ZXPopPickerBlock = ^(NSInteger selectedIndex) {
            if (selectedIndex < 6) {
                relation = contents[selectedIndex];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf diyRelation];
            }
        };
        [self.navigationController.view addSubview:popPicker];
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
    phoneNum = textField.text;
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

- (void)diyRelation
{
    ZXCustomTextFieldViewController *vc = [ZXCustomTextFieldViewController viewControllerFromStoryboard];
    vc.text = relation;
    vc.title = @"自定义身份";
    vc.placeholder = @"自定义身份";
    vc.textBlock = ^(NSString *text) {
        relation = text;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
@end

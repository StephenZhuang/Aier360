//
//  ZXAddABFriendViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/3.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddABFriendViewController.h"
#import <AddressBook/AddressBook.h>
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXValidateHelper.h"
#import "ZXFriend.h"
#import "ZXUser+ZXclient.h"
#import "ZXContactsCell.h"
#import "ZXUserProfileViewController.h"
#import "ZXMyProfileViewController.h"

@implementation ZXPersonTemp

@end

@implementation ZXAddABFriendViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"通讯录好友";
    _addressBookArray = [[NSMutableArray alloc] init];
    _registedArray = [[NSMutableArray alloc] init];
    
    [_tableView setExtrueLineHidden];
    
    hud = [MBProgressHUD showWaiting:@"正在获取通讯录信息" toView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 耗时的操作
        [self loadPerson];
    });
    
}

- (void)loadPerson
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            [self copyAddressBook:addressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [hud turnToError:@"没有获取通讯录权限"];
        });
    }
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);

        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k < ABMultiValueGetCount(phone); k++)
        {
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            if ([personPhone hasPrefix:@"+"]) {
                personPhone = [personPhone substringFromIndex:3];
            }
            
            personPhone = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            personPhone = [personPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            NSLog(@"%@", personPhone);
            if ([ZXValidateHelper checkTel:personPhone needsWarning:NO]) {
                NSArray *array = [ZXFriend where:@{@"uid":@(GLOBAL_UID),@"account":personPhone} limit:@1];
                if (array && array.count > 0) {
                } else {                    
                    ZXPersonTemp *personTemp = [[ZXPersonTemp alloc] init];
                    [personTemp setName:[NSString stringWithFormat:@"%@%@",lastName?lastName:@"",firstName?firstName:@""]];
                    [personTemp setPhone:personPhone];
                    [_addressBookArray addObject:personTemp];
                }
            }
        }
        
    }
    [self loadData];
}

- (void)loadData
{
    NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
    for (ZXPersonTemp *personTemp in _addressBookArray) {
        [phoneArray addObject:personTemp.phone];
    }
    NSString *phones = [phoneArray componentsJoinedByString:@","];
    [ZXUser addAddressFriendWithUid:GLOBAL_UID phones:phones block:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            [_registedArray addObjectsFromArray:array];
            for (ZXUser *user in array) {
                for (int i = (int)_addressBookArray.count - 1; i>=0; i--) {
                    if (i < _addressBookArray.count) {
                        ZXPersonTemp *personTemp = [_addressBookArray objectAtIndex:i];
                        if ([user.account isEqualToString:personTemp.phone]) {
                            user.remark = personTemp.name;
                            [_addressBookArray removeObject:personTemp];
                        } else if ([personTemp.phone isEqualToString:[ZXUtils sharedInstance].user.account]) {
                            [_addressBookArray removeObject:personTemp];
                        }
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [hud hide:YES];
            [self.tableView reloadData];
        });
    }];
}

#pragma mark- 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _registedArray.count;
    } else {
        return _addressBookArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [NSString stringWithFormat:@"%@位好友待添加",@(_registedArray.count)];
    } else {
        return [NSString stringWithFormat:@"%@位朋友待邀请",@(_addressBookArray.count)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:HEADER_TITLE_COLOR];
    
    header.contentView.backgroundColor = HEADER_BG_COLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 55;
    } else {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        ZXUser *user = [self.registedArray objectAtIndex:indexPath.row];
        //0:正常 1：已发送
        switch (user.state) {
            case 0:
            {
                [cell.tagLabel setHidden:YES];
                [cell.agreeButton setHidden:NO];
                [cell.agreeButton setTag:indexPath.row];
            }
                break;
            case 1:
            {
                [cell.tagLabel setHidden:NO];
                [cell.tagLabel setText:@"已发送"];
                [cell.agreeButton setHidden:YES];
            }
                break;
            default:
                break;
        }
        [cell.addressLabel setText:user.remark];
        [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [cell.titleLabel setText:user.nickname];
        return cell;
    } else {
        ZXContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXContactsCell"];
        ZXPersonTemp *personTemp = [_addressBookArray objectAtIndex:indexPath.row];
        [cell.titleLabel setText:personTemp.name];
        cell.agreeButton.tag = indexPath.row;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXUser *user = [self.registedArray objectAtIndex:indexPath.row];
        if (user.uid == GLOBAL_UID) {
            ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
            vc.uid = user.uid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)addFriend:(UIButton *)sender
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证信息" message:@"你需要发送验证申请，等对方通过" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = sender.tag;
    [alertView show];
}

- (IBAction)inviteAction:(UIButton *)sender
{
    ZXPersonTemp *personTemp = [_addressBookArray objectAtIndex:sender.tag];
    if( [MFMessageComposeViewController canSendText] )// 判断设备能不能发送短信
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        // 设置委托
        picker.messageComposeDelegate = self;
        // 默认信息内容
        picker.body = [NSString stringWithFormat:@"我在爱儿邦，爱儿号%@。#免费的幼儿园家校沟通平台# 点击http://phone.aierbon.com 下载安装手机客户端，用手机号注册即可",[ZXUtils sharedInstance].user.aier];
        // 默认收件人(可多个)
        picker.recipients = [NSArray arrayWithObject:personTemp.phone];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        [MBProgressHUD showText:@"该设备不支持短信功能" toView:self.view];
    }
}

#pragma mark-
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *content = [[[alertView textFieldAtIndex:0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (content.length <= 30) {
            ZXUser *user = [_registedArray objectAtIndex:alertView.tag];
            [ZXUser requestFriendWithToUid:user.uid fromUid:GLOBAL_UID content:content block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [MBProgressHUD showSuccess:@"" toView:self.view];
                    user.state = 1;
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:alertView.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                } else {
                    [MBProgressHUD showError:errorInfo toView:self.view];
                }
            }];
        } else {
            [MBProgressHUD showText:@"验证信息不能超过30字" toView:self.view];
        }
    }
}

#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result){
        case MessageComposeResultCancelled:
            NSLog(@"取消发送");
            break;
        case MessageComposeResultFailed:
            [MBProgressHUD showText:@"发送失败" toView:nil];
            break;
        case MessageComposeResultSent:
            [MBProgressHUD showText:@"发送成功" toView:nil];
            break;
            
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
@end

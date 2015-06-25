//
//  ZXUserProfileViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUserProfileViewController.h"
#import "ZXMenuCell.h"
#import "MagicalMacro.h"
#import "ZXUser+ZXclient.h"
#import "ZXProfileDynamicCell.h"
#import "ZXTimeHelper.h"
#import "ZXBabyShownCell.h"
#import "ZXMyInfoViewController.h"
#import "ZXProfileInfoCell.h"
#import "ZXBabyListViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXZipHelper.h"
#import "ZXUserDynamicListViewController.h"
#import "ZXFriend.h"
#import "ChatViewController.h"
#import "NSString+ZXMD5.h"
#import "ZXCustomTextFieldViewController.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>

@implementation ZXUserProfileViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXUserProfileViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isFriend = YES;
    _dynamicCount = 0;
    self.headButton.layer.borderWidth = 2;
    self.headButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headButton.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.headButton.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.headButton.layer.shadowOpacity = 0.7;//阴影透明度，默认0
    self.headButton.layer.shadowRadius = 2;//阴影半径，默认3
    [self updateUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication].keyWindow addSubview:self.userToolView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.userToolView removeFromSuperview];
}

- (void)loadData
{
    [ZXUser getUserInfoAndBabyListWithUid:_uid fuid:GLOBAL_UID block:^(ZXUser *user, NSArray *array, BOOL isFriend, ZXDynamic *dynamic, NSInteger dynamicCount, NSError *error) {
        if (user) {
            _user = user;
        }
        _dynamic = dynamic;
        _dynamicCount = dynamicCount;
        _babyList = array?array:@[];
        _isFriend = isFriend;
        if (!isFriend) {
            NSArray *array = [ZXFriend where:@{@"uid":@(GLOBAL_UID),@"fuid":@(_uid)} limit:@1];
            if (array && array.count > 0) {
                ZXFriend *friend = [array firstObject];
                [friend delete];
                [friend save];
                if (_deleteFriendBlock) {
                    _deleteFriendBlock();
                }
            }
        }
        [self updateUI];
    }];
}

- (void)updateUI
{
    [self.headButton sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:_user.headimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.nameLabel setText:_user.nickname];
    self.title = [_user displayName];
    [self.tableView reloadData];
    [self.userToolView setIsFriend:_isFriend];
    if (_isFriend) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dynamic_bt_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
        self.navigationItem.rightBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
                                 
- (void)moreAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改备注名",@"解除好友关系", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

#pragma mark- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 45;
        } else if (indexPath.row == 1) {
            if (_user.city.length == 0 && _user.desinfo.length == 0) {
                return 45;
            } else {
                return 115;
            }
        } else {
            if (_babyList.count > 0) {
                return _babyList.count * 20 + 25;
            } else {
                return 45;
            }
        }
    } else {
        return 90;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            [cell.titleLabel setText:@"爱儿号"];
            [cell.hasNewLabel setText:[ZXUtils sharedInstance].user.aier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        } else if (indexPath.row == 1) {
            if (_user.city.length == 0 && _user.desinfo.length == 0) {
                ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeholderCell"];
                [cell.titleLabel setText:@"个人资料"];
                [cell.hasNewLabel setText:@"TA还没有编写资料"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else {
                ZXProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXProfileInfoCell"];
                if ([_user.sex isEqualToString:@"男"]) {
                    [cell.sexButton setBackgroundImage:[UIImage imageNamed:@"mine_sexage_male"] forState:UIControlStateNormal];
                } else {
                    [cell.sexButton setBackgroundImage:[UIImage imageNamed:@"mine_sexage_female"] forState:UIControlStateNormal];
                }
                [cell.sexButton setTitle:[NSString stringWithIntger:[ZXTimeHelper ageFromBirthday:_user.birthday]] forState:UIControlStateNormal];
                NSString *imageName = [_user.industry stringByReplacingOccurrencesOfString:@"/" withString:@":"];
                [cell.logoImage setImage:[UIImage imageNamed:imageName]];
                [cell.loacationLabel setText:_user.city.length > 0?_user.city:@"不详"];
                [cell.titleLabel setText:_user.desinfo.length > 0?_user.desinfo:@"这个家伙很懒，什么都没留下"];
                
                return cell;
            }
        } else {
            if (_babyList.count > 0) {
                ZXBabyShownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXBabyShownCell"];
                cell.babyList = _babyList;
                return cell;
            } else {
                ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeholderCell"];
                [cell.titleLabel setText:@"宝宝资料"];
                [cell.hasNewLabel setText:@"TA还没有添加宝宝"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }
    } else {
        ZXProfileDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCell"];
        BOOL hasDynamic = (_dynamic!=nil);
        [cell.tipLabel setHidden:!hasDynamic];
        [cell.titleLabel setHidden:hasDynamic];
        [cell.timeLabel setHidden:!hasDynamic];
        if (_dynamic) {
            [cell.tipLabel setText:_dynamic.content];
            [cell.timeLabel setText:[ZXTimeHelper intervalSinceNow:_dynamic.cdate]];
            if (_dynamic.img.length > 0) {
                NSString *img = [[_dynamic.img componentsSeparatedByString:@","] firstObject];
                [cell.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForFresh:img]];
                cell.logoImage.fd_collapsed = NO;
            } else {
                cell.logoImage.fd_collapsed = YES;
            }
        } else {
            
        }
        [cell.numLabel setText:[NSString stringWithFormat:@"%@",@(_dynamicCount)]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            if (_isFriend) {
                ZXMyInfoViewController *vc = [ZXMyInfoViewController viewControllerFromStoryboard];
                vc.user = _user;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if (indexPath.row == 2) {
            if (_isFriend) {                
                ZXBabyListViewController *vc = [ZXBabyListViewController viewControllerFromStoryboard];
                vc.isMine = (_user.uid == GLOBAL_UID);
                vc.dataArray = [_babyList mutableCopy];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else {
        ZXUserDynamicListViewController *vc = [ZXUserDynamicListViewController viewControllerFromStoryboard];
        vc.uid = _uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)focusAction:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证信息" message:@"你需要发送验证申请，等对方通过" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 1;
    [alertView show];
}

- (IBAction)chatAction:(id)sender
{
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:[_user.account md5] isGroup:NO];
    chatVC.nickName = _user.nickname;
    chatVC.headImage = _user.headimg;
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (actionSheet.tag == 1) {
            //修改备注名
            [self getEditedText:_user.remark indexPath:nil callback:^(NSString *string) {
                [ZXUser changeRemarkWithUid:GLOBAL_UID auid:_uid remark:string block:^(BOOL success, NSString *errorInfo) {
                    if (success) {
                        _user.remark = string;
                    } else {
                        [MBProgressHUD showText:ZXFailedString toView:self.view];
                    }
                }];
            }];
        }
        
    } else if (buttonIndex == 1) {
        // 解除好友关系
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"解除好友关系" message:[NSString stringWithFormat:@"与联系人%@解除好友关系，将同时删除与该联系人的聊天记录",[_user nickname]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 2;
        [alertView show];
    }
}

- (void)getEditedText:(NSString *)fromText indexPath:(NSIndexPath *)indexPath callback:(void(^)(NSString *string))callback
{
    ZXCustomTextFieldViewController *vc = [ZXCustomTextFieldViewController viewControllerFromStoryboard];
    vc.text = fromText;
    vc.title = @"修改备注名";
    vc.placeholder = @"备注名";
    vc.canBeNil = YES;
    vc.textBlock = ^(NSString *text) {
        callback([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        //添加好友
        if (buttonIndex == 1) {
            NSString *content = [[[alertView textFieldAtIndex:0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (content.length <= 30) {
                [ZXUser requestFriendWithToUid:_user.uid fromUid:GLOBAL_UID content:content block:^(BOOL success, NSString *errorInfo) {
                    if (success) {
                        [MBProgressHUD showSuccess:@"" toView:self.view];
                    } else {
                        [MBProgressHUD showError:errorInfo toView:self.view];
                    }
                }];
            } else {
                [MBProgressHUD showText:@"验证信息不能超过30字" toView:self.view];
            }
        }
    } else if (alertView.tag == 2) {
        //解除好友关系
        if (buttonIndex == 1) {
            [self.userToolView setIsFriend:NO];
            [ZXUser deleteFriendWithUid:GLOBAL_UID fuid:_uid block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    _isFriend = NO;
                    
                    if ([[EaseMob sharedInstance].chatManager isLoggedIn]) {
                        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:[_user.account md5] isGroup:NO];
                        [conversation removeAllMessages];
                        [[EaseMob sharedInstance].chatManager removeConversationByChatter:conversation.chatter deleteMessages:NO];
                    }
                } else {
                    [MBProgressHUD showText:NSLocalizedString(@"failed, please retry", nil) toView:self.view];
                    [self.userToolView setIsFriend:YES];
                }
            }];
        }
    }
}


#pragma mark - setters and getters
- (ZXUserToolView *)userToolView
{
    if (!_userToolView) {
        _userToolView = [[ZXUserToolView alloc] initWithIsFriend:_isFriend];
        __weak __typeof(&*self)weakSelf = self;
        _userToolView.chatBlock = ^(void) {
            [weakSelf chatAction:nil];
        };
        _userToolView.addFriendBlock = ^(void) {
            [weakSelf focusAction:nil];
        };
    }
    return _userToolView;
}
@end

//
//  ZXUserDynamicViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUserDynamicViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXZipHelper.h"
#import "ZXUpDownLoadManager.h"
#import "ZXMailBoxViewController.h"
#import "ZXUserMailViewController.h"
#import "ZXDynamic+ZXclient.h"
#import "ZXDynamicToolCell.h"
#import "ZXSChoolDynamicCell.h"
#import "ZXMailCommentCell.h"
#import "ZXImageCell.h"
#import "ZXOriginDynamicCell.h"
#import "ZXAddDynamicViewController.h"
#import "ZXRepostViewController.h"
#import "ZXRepostActionSheet.h"
#import "ZXDynamicDetailViewController.h"
#import "ZXSchoolMessageListViewController.h"
#import "ZXMyInfoViewController.h"
#import "ZXTimeHelper.h"
#import "pureLayout.h"
#import "ZXCustomTextFieldViewController.h"

@interface ZXUserDynamicViewController () {
    NSArray *babyList;
}

@end

@implementation ZXUserDynamicViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXUserDynamicViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
    _logoImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _logoImage.layer.borderWidth = 2;
    
    
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleBordered target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = more;
    
    
    [self getUserInfo];
}

- (void)getUserInfo
{
    [ZXUser getUserInfoAndBabyListWithUid:GLOBAL_UID in_uid:_uid block:^(ZXUser *user, NSArray *array, BOOL isFocus, NSError *error) {
        _user = user;
        
        [self updateUI];
        babyList = array;
    }];
}

- (void)updateUI
{
    self.title = _user.nickname;
    [_logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:_user.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    NSInteger age = [ZXTimeHelper ageFromBirthday:_user.birthday];
    [_memberLabel setText:[NSString stringWithIntger:age]];
    
    
    if ([_user.sex isEqualToString:@"女"]) {
        [_sexImage setImage:[UIImage imageNamed:@"user_sex_female"]];
    } else {
        [_sexImage setImage:[UIImage imageNamed:@"user_sex_male"]];
    }
    
    [_reloationLabel setText:_user.relation];
    
    if (_user.state) {
        [self focusButtonHide];
    }
}

- (void)moreAction
{
    UIActionSheet *actionSheet;
    
    if (_user.state) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"投诉",@"修改备注名",@"取消关注", nil];
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"投诉", nil];
    }
    [actionSheet showInView:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"kong"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:26 green:30 blue:33]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)loadData
{
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXDynamic getDynamicListWithSid:appStateInfo.sid uid:_uid cid:appStateInfo.cid fuid:0 type:ZXDynamicListTypeUser page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZXDynamic *dynamic = [self.dataArray objectAtIndex:section];
    NSInteger commentCount = dynamic.ccount;
    if (commentCount > 2) {
        commentCount = 3;
    }
    if (dynamic.original) {
        //转发
        return 3 + commentCount;
    } else {
        //原创
        if (dynamic.img.length > 0) {
            return 3 + commentCount;
        } else {
            return 2 + commentCount;
        }
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
    NSInteger commentInset = 2;
    NSInteger commentCount = dynamic.ccount;
    if (commentCount > 2) {
        commentCount = 3;
    }
    if (!dynamic.original && dynamic.img.length == 0) {
        commentInset = 1;
    }
    if (indexPath.row == 0) {
        return [ZXSchoolDynamicCell heightByText:dynamic.content];
    }
    
    else if (indexPath.row > 0 && indexPath.row < commentInset) {
        if (dynamic.original) {
            //转发
            return [ZXOriginDynamicCell heightByDynamic:dynamic.dynamic];
        } else {
            //图片
            NSArray *arr = [dynamic.img componentsSeparatedByString:@","];
            return [ZXImageCell heightByImageArray:arr];
        }
    }
    
    else if (indexPath.row >= commentInset && indexPath.row < commentInset+ commentCount) {
        //评论
        NSString *emojiText = @"";
        if (commentCount == 3) {
            if (indexPath.row == commentInset) {
                emojiText = [NSString stringWithFormat:@"查看所有%i条评论",dynamic.ccount];
            } else {
                ZXDynamicComment *dynamicComment = [dynamic.dcList objectAtIndex:(indexPath.row - commentInset - 1)];
                emojiText = [NSString stringWithFormat:@"%@:%@",dynamicComment.nickname , dynamicComment.content];
            }
        } else {
            ZXDynamicComment *dynamicComment = [dynamic.dcList objectAtIndex:(indexPath.row - commentInset)];
            emojiText = [NSString stringWithFormat:@"%@:%@",dynamicComment.nickname , dynamicComment.content];
        }
        return [ZXMailCommentCell heightByText:emojiText];
    }
    else {
        //工具栏
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDynamic *dynamic = [self.dataArray objectAtIndex:indexPath.section];
    NSInteger commentCount = dynamic.ccount;
    if (commentCount > 2) {
        commentCount = 3;
    }
    NSInteger commentInset = 2;
    if (!dynamic.original && dynamic.img.length == 0) {
        commentInset = 1;
    }
    if (indexPath.row == 0) {
        //头
        ZXSchoolDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXSchoolDynamicCell"];
        [cell configureUIWithDynamic:dynamic indexPath:indexPath];
        return cell;
    }
    
    else if (indexPath.row > 0 && indexPath.row < commentInset) {
        if (dynamic.original) {
            //转发
            ZXOriginDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXOriginDynamicCell"];
            [cell configureUIWithDynamic:dynamic.dynamic];
            if (!dynamic.dynamic) {
                [cell.titleLabel setText:@"抱歉，该条内容已被删除"];
            }
            return cell;
        } else {
            //图片
            ZXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImageCell"];
            NSArray *arr = [dynamic.img componentsSeparatedByString:@","];
            [cell setImageArray:arr];
            return cell;
        }
    }
    
    else if (indexPath.row >= commentInset && indexPath.row < commentInset+ commentCount) {
        //评论
        ZXMailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMailCommentCell"];
        cell.emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        cell.emojiLabel.customEmojiPlistName = @"expressionImage";
        [cell.emojiLabel setTextColor:[UIColor colorWithRed:102 green:199 blue:169]];
        if (commentCount == 3) {
            if (indexPath.row == commentInset) {
                [cell.logoImage setHidden:NO];
                [cell.emojiLabel setText:[NSString stringWithFormat:@"查看所有%i条评论",dynamic.ccount]];
            } else {
                [cell.logoImage setHidden:YES];
                ZXDynamicComment *dynamicComment = [dynamic.dcList objectAtIndex:(indexPath.row - commentInset - 1)];
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",dynamicComment.nickname] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:102 green:199 blue:169],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
                NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:dynamicComment.content attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:131 green:131 blue:132],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
                [string appendAttributedString:string2];
                [cell.emojiLabel setText:string];
            }
        } else {
            if (indexPath.row == commentInset) {
                [cell.logoImage setHidden:NO];
            } else {
                [cell.logoImage setHidden:YES];
            }
            ZXDynamicComment *dynamicComment = [dynamic.dcList objectAtIndex:(indexPath.row - commentInset)];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",dynamicComment.nickname] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:102 green:199 blue:169],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:dynamicComment.content attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:131 green:131 blue:132],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
            [string appendAttributedString:string2];
            [cell.emojiLabel setText:string];
        }
        return cell;
    }
    
    else {
    }
    //底部三个按钮
    ZXDynamicToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXDynamicToolCell"];
    [cell configureUIWithDynamic:dynamic indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDynamic *dynamic = self.dataArray[indexPath.section];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    ZXDynamicDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ZXDynamicDetailViewController"];
    vc.type = 3;
    vc.dynamic = dynamic;
    vc.deleteBlock = ^(void) {
        [self.dataArray removeObject:dynamic];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 64) {
        if ([[self.navigationController viewControllers] lastObject] == self) {
            [self.navigationController.navigationBar setHidden:YES];
        }
    } else {
        [self.navigationController.navigationBar setHidden:NO];
    }
}

#pragma -mark button action

- (IBAction)praiseAction:(UIButton *)sender
{
    ZXDynamic *dynamic = self.dataArray[sender.tag];
    sender.selected = !sender.selected;
    NSInteger ptype = 0;
    if (sender.selected) {
        ptype = 0;
        dynamic.pcount++;
    } else {
        ptype = 1;
        dynamic.pcount = MAX(0, dynamic.pcount - 1);
    }
    [sender setTitle:[NSString stringWithIntger:dynamic.pcount] forState:UIControlStateNormal];
    
    [ZXDynamic praiseDynamicWithUid:GLOBAL_UID ptype:ptype did:dynamic.did block:^(BOOL success, NSString *errorInfo) {
        if (!success) {
            [MBProgressHUD showError:ZXFailedString toView:self.view];
        }
    }];
}

- (IBAction)repostAction:(UIButton *)sender
{
    
    if (CURRENT_IDENTITY == ZXIdentitySchoolMaster) {
        [ZXRepostActionSheet showInView:self.view type:ZXIdentitySchoolMaster block:^(NSInteger index) {
            if (index == 0) {
                [self goToRepost:ZXDynamicListTypeUser index:sender.tag];
            } else {
                [self goToRepost:ZXDynamicListTypeSchool index:sender.tag];
            }
        }];
    } else if (CURRENT_IDENTITY == ZXIdentityClassMaster) {
        [ZXRepostActionSheet showInView:self.view type:ZXIdentityClassMaster block:^(NSInteger index) {
            if (index == 0) {
                [self goToRepost:ZXDynamicListTypeUser index:sender.tag];
            } else {
                [self goToRepost:ZXDynamicListTypeClass index:sender.tag];
            }
        }];
    } else {
        [self goToRepost:ZXDynamicListTypeUser index:sender.tag];
    }
    
    
    
}

- (void)goToRepost:(ZXDynamicListType)type index:(NSInteger)index
{
    ZXDynamic *dynamic = self.dataArray[index];
    if (dynamic.original) {
        if (!dynamic.dynamic) {
            [MBProgressHUD showError:@"原动态已被删除，不能转发" toView:self.view];
            return;
        }
    }
    ZXRepostViewController *vc = [[UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXRepostViewController"];
    vc.dynamic = dynamic;
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 投诉
        [ZXUser complaintWithUid:GLOBAL_UID in_uid:_uid block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [MBProgressHUD showText:@"投诉成功" toView:self.view];
            } else {
                [MBProgressHUD showText:ZXFailedString toView:self.view];
            }
        }];
        
    } else if (buttonIndex == 1) {
        //TODO: 修改备注名
        [self getEditedText:_user.remark indexPath:nil callback:^(NSString *string) {
            [ZXUser changeRemarkWithUid:GLOBAL_UID auid:_uid remark:string block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    _user.remark = string;
                } else {
                    [MBProgressHUD showText:ZXFailedString toView:self.view];
                }
            }];
        }];
        
    } else if (buttonIndex == 2) {
        // 取消关注
        [self focusButtonShow];
        [ZXUser cancelFocusWithUid:GLOBAL_UID fuidStr:[NSString stringWithIntger:_uid] block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                _user.state = 0;
            } else {
                [MBProgressHUD showText:NSLocalizedString(@"failed, please retry", nil) toView:self.view];
                [self focusButtonHide];
            }
        }];
    }
}

- (IBAction)infoAction:(id)sender
{
    if (babyList == nil) {
        
        do {
            sleep(1);
        } while (babyList == nil);
        
    }
    
    [self performSegueWithIdentifier:@"info" sender:nil];
}

- (IBAction)focusAction:(id)sender
{
    [self focusButtonHide];
    // 关注
    [ZXUser focusWithUid:GLOBAL_UID fuid:_uid block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            _user.state = 1;
            
        } else {
            [MBProgressHUD showText:ZXFailedString toView:self.view];
            [self focusButtonShow];
        }
    }];
}

- (IBAction)chatAction:(id)sender
{
    //TODO: 聊天
}

- (void)focusButtonHide
{
    [UIView animateWithDuration:0.5 animations:^{
        _focusButton.alpha = 0;
        
        [_buttonSpace autoRemove];
        _buttonAlign = [_chatButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)focusButtonShow
{
    [UIView animateWithDuration:0.5 animations:^{
        _focusButton.alpha = 1;
        
        [_buttonAlign autoRemove];
        _buttonSpace = [_chatButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_focusButton withOffset:20];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)getEditedText:(NSString *)fromText indexPath:(NSIndexPath *)indexPath callback:(void(^)(NSString *string))callback
{
    ZXCustomTextFieldViewController *vc = [ZXCustomTextFieldViewController viewControllerFromStoryboard];
    vc.text = fromText;
    vc.title = @"修改备注名";
    vc.placeholder = @"备注名";
    vc.textBlock = ^(NSString *text) {
        callback(text);
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"info"]) {
        ZXMyInfoViewController *vc = [segue destinationViewController];
        vc.user = _user;
        vc.babyList = babyList;
        vc.editSuccess = ^(void) {
            [self getUserInfo];
        };
    }
}
@end

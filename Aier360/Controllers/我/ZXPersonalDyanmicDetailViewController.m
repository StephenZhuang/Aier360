//
//  ZXPersonalDyanmicDetailViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDyanmicDetailViewController.h"
#import "ZXUser+ZXclient.h"
#import "ZXDynamic+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXDynamicDetailView.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "ZXFavourCell.h"
#import "ZXFavourListViewController.h"
#import "ZXReleaseMyDynamicViewController.h"
#import "ZXCommentCell.h"
#import "UIViewController+ZXPhotoBrowser.h"
#import "ZXPopMenu.h"
#import "ZXCollection+ZXclient.h"
#import "ZXMyProfileViewController.h"
#import "ZXUserProfileViewController.h"
#import "NSManagedObject+ZXRecord.h"

@interface ZXPersonalDyanmicDetailViewController ()
{
    long dcid;
    NSString *rname;
    long touid;
    NSInteger totalPraised;
}
@end

@implementation ZXPersonalDyanmicDetailViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXPersonalDyanmicDetailViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"详情";
    _emojiPicker.emojiBlock = ^(NSString *text) {
        self.commentToolBar.textField.text = [self.commentToolBar.textField.text stringByAppendingString:text];
    };
    touid = self.dynamic.uid;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dynamic_bt_more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (IBAction)moreAction:(id)sender
{
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    if (self.dynamic.type == 3 && self.dynamic.uid != GLOBAL_UID) {
        [contents addObject:@"转发至好友圈"];
    }
    if (self.dynamic.hasCollection == 1) {
        [contents addObject:@"取消收藏"];
    } else {
        [contents addObject:@"收藏"];
    }
    if ((self.dynamic.type != 3 && HASIdentyty(ZXIdentitySchoolMaster)) || (self.dynamic.type == 2 && HASIdentytyWithCid(ZXIdentityClassMaster, self.dynamic.cid)) || (self.dynamic.type == 3 && GLOBAL_UID == self.dynamic.uid)) {
        [contents addObject:@"删除"];
    }
    __weak __typeof(&*self)weakSelf = self;
    ZXPopMenu *menu = [[ZXPopMenu alloc] initWithContents:contents targetFrame:CGRectMake(0, 0, self.view.frame.size.width - 15, 64)];
    menu.ZXPopPickerBlock = ^(NSInteger index) {
        NSString *string = [contents objectAtIndex:index];
        if ([string isEqualToString:@"转发至好友圈"]) {
            ZXReleaseMyDynamicViewController *vc = [ZXReleaseMyDynamicViewController viewControllerFromStoryboard];
            vc.isRepost = YES;
            vc.dynamic = weakSelf.dynamic;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else if ([string isEqualToString:@"删除"]) {
            MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
            [ZXPersonalDynamic deleteDynamicWithDid:_did type:weakSelf.dynamic.type block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    [hud turnToSuccess:@""];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [hud turnToError:errorInfo];
                }
            }];
        } else {
            BOOL isAdd = weakSelf.dynamic.hasCollection==0;
            if (_isCachedDynamic) {
                [weakSelf.dynamic save];
            }
            [ZXCollection collectWithUid:GLOBAL_UID did:_did isAdd:isAdd block:^(BOOL success, NSString *errorInfo) {
                if (success) {
                    if (isAdd) {
                        weakSelf.dynamic.hasCollection = 1;
                        [MBProgressHUD showText:@"收藏成功" toView:self.view];
                    } else {
                        weakSelf.dynamic.hasCollection = 0;
                        [MBProgressHUD showText:@"取消收藏成功" toView:self.view];
                    }
                    if (_isCachedDynamic) {
                        [weakSelf.dynamic save];
                    }
                } else {
                    [MBProgressHUD showText:errorInfo toView:self.view];
                }
            }];
        }
    };
    [self.navigationController.view addSubview:menu];
}

- (void)loadData
{
    if (page == 1) {
        [ZXUser getPrasedUserWithDid:_did limitNumber:5 block:^(NSArray *array, NSInteger total, NSError *error) {
            [_prasedUserArray removeAllObjects];
            [_prasedUserArray addObjectsFromArray:array];
            totalPraised = total;
            [self.tableView reloadData];
        }];
        
        if (!self.dynamic) {
            [ZXPersonalDynamic getPersonalDynamicDetailWithUid:GLOBAL_UID did:_did block:^(ZXPersonalDynamic *dynamic, NSError *error) {
                if (dynamic) {
                    self.dynamic = dynamic;
                    touid = dynamic.uid;
                    [self.tableView reloadData];
                } else {
                    [MBProgressHUD showText:@"动态已经不存在" toView:self.view];
                }
            }];
        }
    }
    
    [ZXDynamic getDynamicCommentListWithDid:_did page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (IBAction)commentAction:(id)sender
{
    [self.view endEditing:YES];
    [self.commentToolBar.emojiButton setSelected:NO];
    if (_emojiPicker.showing) {
        [_emojiPicker hide];
        self.commentToolBar.transform = CGAffineTransformIdentity;
    }
    NSString *content = [[self.commentToolBar.textField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    
    if (dcid) {
        [ZXDynamic replyDynamicCommentWithUid:GLOBAL_UID dcid:dcid rname:rname ruid:touid content:content type:self.dynamic.type==3?2:1 block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@""];
                self.commentToolBar.textField.text = @"";
                self.commentToolBar.textField.placeholder = @"发布评论";
                dcid = 0;
                rname = @"";
                touid = _dynamic.uid;
            } else {
                [hud turnToError:errorInfo];
            }
        }];
        
    } else {
        [ZXDynamic commentDynamicWithUid:GLOBAL_UID did:_did content:content type:self.dynamic.type==3?2:1 block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                self.commentToolBar.textField.text = @"";
                self.commentToolBar.textField.placeholder = @"发布评论";
                [hud turnToSuccess:@""];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self commentAction:nil];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.commentToolBar.emojiButton setSelected:NO];
    if (_emojiPicker.showing) {
        [_emojiPicker hide];
        self.commentToolBar.transform = CGAffineTransformIdentity;
    }
}

- (IBAction)emojiAction:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    [self.view endEditing:YES];
    if (sender.selected) {
        [_emojiPicker show];
        [UIView animateWithDuration:0.25 animations:^{
            self.commentToolBar.transform = CGAffineTransformTranslate(self.commentToolBar.transform, 0, - CGRectGetHeight(_emojiPicker.frame));
        }];
    } else {
        [_emojiPicker hide];
        [UIView animateWithDuration:0.25 animations:^{
            self.commentToolBar.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (IBAction)deleteAction:(UIButton *)sender
{
    [ZXDynamic deleteDynamicWithDid:_did block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [MBProgressHUD showSuccess:@"" toView:nil];
//            if (_deleteBlock) {
//                _deleteBlock();
//            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:ZXFailedString toView:self.view];
        }
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dynamic) {
        if (section == 2) {
            return self.dataArray.count;
        }
        return 1;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.dynamic) {
            return [tableView fd_heightForCellWithIdentifier:@"ZXDynamicDetailView" configuration:^(ZXDynamicDetailView *cell) {
                [cell configureWithDynamic:self.dynamic];
            }];
        } else {
            return 0;
        }
    } else if (indexPath.section == 1) {
        return 40;
    } else {
        ZXDynamicComment *dynamicComment = [self.dataArray objectAtIndex:indexPath.row];
        return [tableView fd_heightForCellWithIdentifier:@"ZXCommentCell" configuration:^(ZXCommentCell *cell) {
            [cell setDynamicComment:dynamicComment];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXDynamicDetailView *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXDynamicDetailView"];
        if (self.dynamic) {
            __weak __typeof(&*self)weakSelf = self;
            [cell configureWithDynamic:self.dynamic];
            cell.imageClickBlock = ^(NSInteger index) {
                NSString *img = weakSelf.dynamic.original==1?weakSelf.dynamic.dynamic.img:weakSelf.dynamic.img;
                NSArray *array = [img componentsSeparatedByString:@","];
                [weakSelf browseImage:array type:ZXImageTypeFresh index:index];
            };
        }
        return cell;
    } else if (indexPath.section == 1) {
        ZXFavourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXFavourCell"];
        [cell configureCellWithUsers:self.prasedUserArray total:totalPraised];
        __weak __typeof(&*self)weakSelf = self;
        cell.userClickBlick = ^(long uid) {
            if (uid == GLOBAL_UID) {
                ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
                vc.uid = uid;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    } else {
        __weak __typeof(&*self)weakSelf = self;
        ZXDynamicComment *dynamicComment = [self.dataArray objectAtIndex:indexPath.row];
        ZXCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCommentCell"];
        cell.dynamicComment = dynamicComment;
        cell.commentIcon.hidden = indexPath.row!=0;
        cell.userBlock = ^(long uid) {
            //进入个人主页
            if (uid == GLOBAL_UID) {
                ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
                vc.uid = uid;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        cell.replyBlock = ^(ZXDynamicCommentReply *reply) {
            if (reply.uid == GLOBAL_UID) {
                [MBProgressHUD showText:@"不能回复自己" toView:self.view];
            } else {
                dcid = reply.dcid;
                rname = reply.nickname;
                touid = reply.uid;
                weakSelf.commentToolBar.textField.placeholder = [NSString stringWithFormat:@"回复 %@:",reply.nickname];
                [weakSelf.commentToolBar.textField becomeFirstResponder];
            }
        };
        
        BOOL hasSuperDeleteRule = NO;
        if (self.dynamic.type != 3) {
            if (HASIdentyty(ZXIdentitySchoolMaster) || (self.dynamic.type == 2 && HASIdentytyWithCid(ZXIdentityClassMaster, self.dynamic.cid))) {
                hasSuperDeleteRule = YES;
            }
        }
        cell.hasSuperDeleteRule = hasSuperDeleteRule;
        cell.deleteCommentBlock = ^(BOOL isComment,long relativeId) {
            if (isComment) {
                [ZXDynamic deleteCommentDynamicWithDcid:relativeId block:^(BOOL success, NSString *errorInfo) {
                    if (success) {
                        [MBProgressHUD showSuccess:@"" toView:self.view];
                        [weakSelf.tableView headerBeginRefreshing];
                    } else {
                        [MBProgressHUD showError:errorInfo toView:self.view];
                    }
                }];
            } else {
                [ZXDynamic deleteReplyWithDcrid:relativeId block:^(BOOL success, NSString *errorInfo) {
                    if (success) {
                        [MBProgressHUD showSuccess:@"" toView:self.view];
                        [weakSelf.tableView headerBeginRefreshing];
                    } else {
                        [MBProgressHUD showError:errorInfo toView:self.view];
                    }
                }];
            }
        };
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.prasedUserArray.count > 0) {            
            ZXFavourListViewController *vc = [ZXFavourListViewController viewControllerFromStoryboard];
            vc.did = _did;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 2) {
        ZXDynamicComment *dynamicComment = [self.dataArray objectAtIndex:indexPath.row];
        if (dynamicComment.uid == GLOBAL_UID) {
            [MBProgressHUD showText:@"不能回复自己" toView:self.view];
        } else {
            dcid = dynamicComment.dcid;
            rname = dynamicComment.nickname;
            touid = dynamicComment.uid;
            self.commentToolBar.textField.placeholder = [NSString stringWithFormat:@"回复 %@:",dynamicComment.nickname];
            [self.commentToolBar.textField becomeFirstResponder];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -mark setters and getters
- (NSMutableArray *)prasedUserArray
{
    if (!_prasedUserArray) {
        _prasedUserArray = [[NSMutableArray alloc] init];
    }
    return _prasedUserArray;
}
@end

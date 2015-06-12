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

@interface ZXPersonalDyanmicDetailViewController ()
{
    NSInteger dcid;
    NSString *rname;
    NSInteger touid;
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

- (IBAction)moreAction:(id)sender
{
    ZXReleaseMyDynamicViewController *vc = [ZXReleaseMyDynamicViewController viewControllerFromStoryboard];
    vc.isRepost = YES;
    vc.dynamic = self.dynamic;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    if (dcid) {
        [ZXDynamic replyDynamicCommentWithUid:GLOBAL_UID dcid:dcid rname:rname content:content touid:touid block:^(BOOL success, NSString *errorInfo) {
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
        [ZXDynamic commentDynamicWithUid:GLOBAL_UID sid:appStateInfo.sid did:_did content:content type:_dynamic.type filePath:nil touid:touid block:^(BOOL success, NSString *errorInfo) {
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.dynamic) {
            return [tableView fd_heightForCellWithIdentifier:@"ZXDynamicDetailView" cacheByIndexPath:indexPath configuration:^(ZXDynamicDetailView *cell) {
                [cell configureWithDynamic:self.dynamic];
            }];
        } else {
            return 0;
        }
    } else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZXDynamicDetailView *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXDynamicDetailView"];
        if (self.dynamic) {
            [cell configureWithDynamic:self.dynamic];
        }
        return cell;
    } else {
        ZXFavourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXFavourCell"];
        [cell configureCellWithUsers:self.prasedUserArray total:totalPraised];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        ZXFavourListViewController *vc = [ZXFavourListViewController viewControllerFromStoryboard];
        vc.did = _did;
        [self.navigationController pushViewController:vc animated:YES];
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

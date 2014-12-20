//
//  ZXDynamicDetailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicDetailViewController.h"
#import "ZXSChoolDynamicCell.h"
#import "ZXOriginDynamicCell.h"
#import "ZXImageCell.h"
#import "ZXCommentCountCell.h"
#import "ZXDynamicCommentCell.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXPraiseListViewController.h"

@interface ZXDynamicDetailViewController ()

@end

@implementation ZXDynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"详情";
    _emojiPicker.emojiBlock = ^(NSString *text) {
        _commentTextField.text = [_commentTextField.text stringByAppendingString:text];
    };
}

- (void)loadData
{
    [ZXDynamic getDynamicCommentListWithDid:_dynamic.did page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        if (array) {
            for (ZXDynamicComment *comment in array) {
                [self.dataArray addObject:comment];
                if (comment.dcrList) {
                    [self.dataArray addObjectsFromArray:comment.dcrList];
                }
            }
            
            if (array.count < pageCount) {
                hasMore = NO;
                [self.tableView setFooterHidden:YES];
            }
        } else {
            hasMore = NO;
            [self.tableView setFooterHidden:YES];
        }
        [self.tableView reloadData];
        if (page == 1) {
            [self.tableView headerEndRefreshing];
        } else {
            [self.tableView footerEndRefreshing];
        }
    }];
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_dynamic.original) {
            return 2;
        } else {
            if (_dynamic.img.length > 0) {
                return 2;
            } else {
                return 1;
            }
        }
    } else if (section == 1) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            return [ZXSchoolDynamicCell heightByText:_dynamic.content];
        } else {
            if (_dynamic.original) {
                //转发
                return [ZXOriginDynamicCell heightByDynamic:_dynamic.dynamic];
            } else {
                //图片
                NSArray *arr = [_dynamic.img componentsSeparatedByString:@","];
                return [ZXImageCell heightByImageArray:arr];
            }
        }
    } else if (indexPath.section == 1){
        return 65;
    } else {
        NSObject *object = [self.dataArray objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[ZXDynamicComment class]]) {
            ZXDynamicComment *comment = (ZXDynamicComment *)object;
            return [ZXDynamicCommentCell heightByEmojiText:comment.content];
        } else {
            ZXDynamicCommentReply *commentReply = (ZXDynamicCommentReply *)object;
            return [ZXDynamicCommentCell heightByEmojiText:commentReply.content];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            ZXSchoolDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXSchoolDynamicCell"];
            [cell configureUIWithDynamic:_dynamic indexPath:indexPath];
            if (((CURRENT_IDENTITY == ZXIdentitySchoolMaster) && (_type == 1)) || ((CURRENT_IDENTITY == ZXIdentityClassMaster) && (_type == 2)) || ((_type == 3) && (_dynamic.uid == GLOBAL_UID))) {
                [cell.deleteButton setHidden:NO];
            } else {
                [cell.deleteButton setHidden:YES];
            }
            return cell;
        } else {
            if (_dynamic.original) {
                //转发
                ZXOriginDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXOriginDynamicCell"];
                [cell configureUIWithDynamic:_dynamic.dynamic];
                return cell;
            } else {
                //图片
                ZXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImageCell"];
                NSArray *arr = [_dynamic.img componentsSeparatedByString:@","];
                [cell setImageArray:arr];
                return cell;
            }
        }
    } else if (indexPath.section == 1){
        ZXCommentCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXCommentCountCell"];
        if (_dynamic.pcount > 0) {
            [cell.praiseCountLabel setText:[NSString stringWithFormat:@"%i人赞过这条动态",_dynamic.pcount]];
            [cell.praiseDetailButton setHidden:NO];
        } else {
            [cell.praiseCountLabel setText:@"还没有人赞过这条动态"];
            [cell.praiseDetailButton setHidden:YES];
        }
        [cell.commentCountLabel setText:[NSString stringWithFormat:@"评论(%i):",_dynamic.ccount]];
        return cell;
    } else {
        ZXDynamicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXDynamicCommentCell"];
        if ([[self.dataArray objectAtIndex:indexPath.row] isKindOfClass:[ZXDynamicComment class]]) {
            [cell configureUIWithDynamicComment:[self.dataArray objectAtIndex:indexPath.row]];
        } else {
            [cell configureUIWithDynamicCommentReply:[self.dataArray objectAtIndex:indexPath.row]];
        }
        return cell;
    }
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if ([[self.dataArray objectAtIndex:indexPath.row] isKindOfClass:[ZXDynamicComment class]]) {
            ZXDynamicComment *comment = [self.dataArray objectAtIndex:indexPath.row];
            if (comment.uid == GLOBAL_UID) {
                [MBProgressHUD showText:@"不能回复自己" toView:self.view];
            } else {
                dcid = comment.dcid;
                rname = comment.nickname;
                _commentTextField.placeholder = [NSString stringWithFormat:@"回复 %@:",comment.nickname];
                [_commentTextField becomeFirstResponder];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)commentAction:(id)sender
{
    [self.view endEditing:YES];
    [_emojiButton setSelected:NO];
    if (_emojiPicker.showing) {
        [_emojiPicker hide];
        self.toolView.transform = CGAffineTransformIdentity;
    }
    NSString *content = [[_commentTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0) {
        return;
    }
    
    ZXAppStateInfo *appStateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    if (dcid) {
        [ZXDynamic replyDynamicCommentWithUid:GLOBAL_UID dcid:dcid rname:rname content:content block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [MBProgressHUD showSuccess:@"" toView:self.view];
                _commentTextField.text = @"";
                _commentTextField.placeholder = @"发布评论";
                dcid = 0;
                rname = @"";
            } else {
                [MBProgressHUD showError:errorInfo toView:self.view];
            }
        }];
        
    } else {
        [ZXDynamic commentDynamicWithUid:GLOBAL_UID sid:appStateInfo.sid did:_dynamic.did content:content type:_dynamic.type filePath:nil block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                _commentTextField.text = @"";
                _commentTextField.placeholder = @"发布评论";
                [MBProgressHUD showSuccess:@"" toView:self.view];
            } else {
                [MBProgressHUD showError:errorInfo toView:self.view];
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
    [_emojiButton setSelected:NO];
    if (_emojiPicker.showing) {
        [_emojiPicker hide];
        self.toolView.transform = CGAffineTransformIdentity;
    }
}

- (IBAction)emojiAction:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    [self.view endEditing:YES];
    if (sender.selected) {
        [_emojiPicker show];
        [UIView animateWithDuration:0.25 animations:^{
            self.toolView.transform = CGAffineTransformTranslate(self.toolView.transform, 0, - CGRectGetHeight(_emojiPicker.frame));
        }];
    } else {
        [_emojiPicker hide];
        [UIView animateWithDuration:0.25 animations:^{
            self.toolView.transform = CGAffineTransformIdentity;
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
    [ZXDynamic deleteDynamicWithDid:_dynamic.did block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [MBProgressHUD showSuccess:@"" toView:nil];
            if (_deleteBlock) {
                _deleteBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:ZXFailedString toView:self.view];
        }
    }];
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
    if ([segue.identifier isEqualToString:@"praiseDetail"]) {
        ZXPraiseListViewController *vc = segue.destinationViewController;
        vc.did = _dynamic.did;
    }
}


@end

//
//  ZXCommentViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/25.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCommentViewController.h"
#import "ZXDynamic+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXCommentViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXCommentViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.view.backgroundColor = [UIColor clearColor];
    _emojiPicker.emojiBlock = ^(NSString *text) {
        self.commentToolBar.textField.text = [self.commentToolBar.textField.text stringByAppendingString:text];
    };
    [self.commentToolBar.textField becomeFirstResponder];
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
    

    [ZXDynamic commentDynamicWithUid:GLOBAL_UID did:_did content:content type:_type==3?2:1 block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            self.commentToolBar.textField.text = @"";
            self.commentToolBar.textField.placeholder = @"发布评论";
            [hud turnToSuccess:@""];
            !_commentBlock?:_commentBlock();
            [self.view removeFromSuperview];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
    
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view removeFromSuperview];
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.commentToolBar.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.commentToolBar.transform = CGAffineTransformIdentity;
    }];
}
@end

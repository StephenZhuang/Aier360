//
//  ZXAddMailViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddMailViewController.h"
#import "ZXSchoolMasterEmail+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXAddMailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"留言";
    [_textView setPlaceholder:@"想对TA说..."];
    
    _emojiPicker.emojiBlock = ^(NSString *text) {
        _textView.text = [_textView.text stringByAppendingString:text];
    };
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)submit
{
    [self.view endEditing:YES];
    NSString *content = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"发送中" toView:nil];
    ZXAppStateInfo *stateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    [ZXSchoolMasterEmail sendEmailWithSuid:GLOBAL_UID sid:stateInfo.sid content:content block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [hud turnToSuccess:@""];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
}

- (IBAction)emojiAction:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        [self.view endEditing:YES];
        [_emojiPicker show];
    } else {
        [_emojiPicker hide];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_emojiButton setSelected:NO];
    if (_emojiPicker.showing) {
        [_emojiPicker hide];
    }
}
@end

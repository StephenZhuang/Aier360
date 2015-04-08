//
//  ZXCustomTextFieldViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCustomTextFieldViewController.h"

@implementation ZXCustomTextFieldViewController

+ (instancetype)viewControllerFromStoryboard
{
    return [[UIStoryboard storyboardWithName:@"School" bundle:nil] instantiateViewControllerWithIdentifier:@"ZXCustomTextFieldViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
    [item setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = item;
    
    if (_text) {
        [_textField setText:_text];
    }
    
    if (_placeholder) {
        [_textField setPlaceholder:_placeholder];
    }
    
    [_textField becomeFirstResponder];
}

- (void)submit
{
    [self.view endEditing:YES];
    if (_textField.text.length == 0 && !_canBeNil) {
        return;
    }
    if (_textBlock) {
        _textBlock(_textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end

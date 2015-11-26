//
//  ZXSendMessageToUnactiveViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/17.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSendMessageToUnactiveViewController.h"
#import "ZXTeacherNew+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXSendMessageToUnactiveViewController ()

@end

@implementation ZXSendMessageToUnactiveViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Teachers" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSendMessageToUnactiveViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑短信";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.textView.text = self.content;
}

- (void)sendAction
{
    [self.view endEditing:YES];
    NSString *string = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length == 0) {
        [MBProgressHUD showText:@"请输入内容" toView:self.view];
        return;
    } else {
        MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
        [ZXTeacherNew sendMessageToUnactiveWithSid:[ZXUtils sharedInstance].currentSchool.sid cid:self.cid messageStr:string block:^(BOOL success, NSString *errorInfo) {
            if (success) {
                [hud turnToSuccess:@"短信发送成功"];
                !_sendSuccess?:_sendSuccess();
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [hud turnToError:errorInfo];
            }
        }];
    }
}


#pragma mark - textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

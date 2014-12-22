//
//  ZXRepostViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRepostViewController.h"

@interface ZXRepostViewController ()

@end

@implementation ZXRepostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)customInterface
{
    self.title = @"转发";
    [self.textView setPlaceholder:@"想说点什么"];
    [self.textView setText:[NSString stringWithFormat:@"//%@:%@",_dynamic.nickname,_dynamic.content]];
    self.textView.selectedRange = NSMakeRange(0 ,0);
    [self.textView becomeFirstResponder];
}

- (void)submit
{
    [self.view endEditing:YES];
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length == 0) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"发送中" toView:nil];
    ZXAppStateInfo *stateInfo = [ZXUtils sharedInstance].currentAppStateInfo;
    NSInteger did = _dynamic.did;
    if (_dynamic.original) {
        did = _dynamic.dynamic.did;
    }
    [ZXDynamic repostDynamicWithUid:GLOBAL_UID sid:stateInfo.sid cid:stateInfo.cid content:content type:_type did:
     did touid:_dynamic.uid block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [hud turnToSuccess:@""];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [hud turnToError:errorInfo];
        }
    }];
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

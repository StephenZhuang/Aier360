//
//  ZXMessageEditViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/10.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageEditViewController.h"
#import "ZXSendAnnouncementMessageViewController.h"

@implementation ZXMessageEditViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXMessageEditViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑短信";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction:)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.textView.text = self.announceMessage.content;
    [self textViewDidChange:self.textView];
}

- (IBAction)nextAction:(id)sender
{
    [self.view endEditing:YES];
    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (content.length > 0) {
        self.announceMessage.content = content;
        self.announceMessage.messageNum = [ZXAnnounceMessage getMessageNumWithTextlength:content.length];
        
        ZXSendAnnouncementMessageViewController *vc = [ZXSendAnnouncementMessageViewController viewControllerFromStoryboard];
        vc.announceMessage = self.announceMessage;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self.letterNumLabel setText:[NSString stringWithFormat:@"%@",@(textView.text.length)]];
    NSInteger num = [ZXAnnounceMessage getMessageNumWithTextlength:textView.text.length];
    [self.messageNumLabel setText:[NSString stringWithFormat:@"%@",@(num)]];
}

@end

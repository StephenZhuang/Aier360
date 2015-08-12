//
//  ZXAnnouncementContentCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementContentCell.h"

@implementation ZXAnnouncementContentCell
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger length = self.textView.text.length;
    [self.letterLabel setText:[NSString stringWithFormat:@"%@",@(300-length)]];
    !_textBlock?:_textBlock(self.textView.text);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end

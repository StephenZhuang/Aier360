//
//  ZXAnnouncementTitleCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementTitleCell.h"

@implementation ZXAnnouncementTitleCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textDidChange:(NSNotification *)nitification
{
    NSInteger length = self.textField.text.length;
    [self.letterLabel setText:[NSString stringWithFormat:@"%@",@(10-length)]];
    !_textBlock?:_textBlock(self.textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end

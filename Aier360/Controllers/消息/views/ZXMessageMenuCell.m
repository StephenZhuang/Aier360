//
//  ZXMessageMenuCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/8.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageMenuCell.h"
#import "MagicalMacro.h"

@interface ZXMessageMenuCell ()
{
    UIView *_lineView;
}
@end

@implementation ZXMessageMenuCell
- (void)awakeFromNib
{
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
//    _lineView.backgroundColor = sz_(207, 210, 213, 0.7);
    _lineView.backgroundColor = [UIColor colorWithRed:207/255.0 green:210/255.0 blue:213/255.0 alpha:0.7];
    [self.contentView addSubview:_lineView];
}

- (void)setMessageNum:(NSInteger)messageNum
{
    _messageNum = messageNum;
    [self.badgeLabel setText:[NSString stringWithFormat:@"%@",@(messageNum)]];
    if (messageNum > 0) {
        [self.badgeLabel setHidden:NO];
    } else {
        [self.badgeLabel setHidden:YES];
    }
}
@end

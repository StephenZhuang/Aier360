//
//  ZXReplyCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXReplyCell.h"

@implementation ZXReplyCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.emojiLabel.backgroundColor = [UIColor clearColor];
    self.emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.emojiLabel.isNeedAtAndPoundSign = YES;
    self.emojiLabel.disableEmoji = NO;
    self.emojiLabel.disableThreeCommon = NO;
    
    self.emojiLabel.lineSpacing = 3.0f;
    
    self.emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    self.emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.emojiLabel.customEmojiPlistName = @"expressionImage";
}
@end

//
//  ZXMailCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMailCell.h"
#import "MagicalMacro.h"

@implementation ZXMailCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    _emojiLabel.numberOfLines = 0;
    _emojiLabel.font = [UIFont systemFontOfSize:17.0f];
    _emojiLabel.delegate = self;
    _emojiLabel.backgroundColor = [UIColor clearColor];
    _emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _emojiLabel.textColor = [UIColor whiteColor];
    _emojiLabel.backgroundColor = [UIColor colorWithRed:0.218 green:0.809 blue:0.304 alpha:1.000];
    
    _emojiLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _emojiLabel.isNeedAtAndPoundSign = YES;
    _emojiLabel.disableEmoji = NO;
    
    _emojiLabel.lineSpacing = 3.0f;
    
    _emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _emojiLabel.customEmojiPlistName = @"expressionImage.plist";
}

+ (CGFloat)heightByText:(NSString *)emojiText
{
    return [MLEmojiLabel heightForEmojiText:emojiText preferredWidth:(SCREEN_WIDTH - 30) fontSize:17] + 95;
}
@end

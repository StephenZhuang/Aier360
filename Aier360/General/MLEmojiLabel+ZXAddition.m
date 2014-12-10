//
//  MLEmojiLabel+ZXAddition.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "MLEmojiLabel+ZXAddition.h"

@implementation MLEmojiLabel (ZXAddition)
+ (CGFloat)heightForEmojiText:(NSString*)emojiText preferredWidth:(CGFloat)width fontSize:(CGFloat)fontSize
{
    static MLEmojiLabel *protypeLabel = nil;
    if (!protypeLabel) {
        protypeLabel = [MLEmojiLabel new];
        protypeLabel.numberOfLines = 0;
        protypeLabel.lineBreakMode = NSLineBreakByCharWrapping;
        protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        protypeLabel.isNeedAtAndPoundSign = YES;
        protypeLabel.disableEmoji = NO;
        protypeLabel.lineSpacing = 3.0f;
        
        protypeLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        protypeLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        protypeLabel.customEmojiPlistName = @"expressionImage.plist";
    }
    
    protypeLabel.font = [UIFont systemFontOfSize:fontSize];
    [protypeLabel setText:emojiText];
    
    return [protypeLabel preferredSizeWithMaxWidth:width].height+5.0f*2;
}
@end

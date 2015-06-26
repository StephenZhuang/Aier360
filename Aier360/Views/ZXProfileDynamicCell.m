//
//  ZXProfileDynamicCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/17.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXProfileDynamicCell.h"

@implementation ZXProfileDynamicCell
- (void)awakeFromNib
{
    _tipLabel.numberOfLines = 2;
    _tipLabel.font = [UIFont systemFontOfSize:17.0f];
    _tipLabel.delegate = self;
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _tipLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _tipLabel.isNeedAtAndPoundSign = YES;
    _tipLabel.disableEmoji = NO;
    _tipLabel.disableThreeCommon = YES;
    
    _tipLabel.lineSpacing = 3.0f;
    
    _tipLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    _tipLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _tipLabel.customEmojiPlistName = @"expressionImage";
    
    self.logoImage.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.logoImage.layer.masksToBounds = YES;
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}
@end

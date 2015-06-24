//
//  ZXPersonalDynamicCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/9.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPersonalDynamicCell.h"

@implementation ZXPersonalDynamicCell
- (void)awakeFromNib
{
    _repostLabel.font = [UIFont systemFontOfSize:17.0f];
    _repostLabel.delegate = self;
    _repostLabel.backgroundColor = [UIColor clearColor];
    _repostLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _repostLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _repostLabel.isNeedAtAndPoundSign = YES;
    _repostLabel.disableEmoji = NO;
    _repostLabel.disableThreeCommon = YES;
    
    _repostLabel.lineSpacing = 3.0f;
    
    _repostLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    _repostLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _repostLabel.customEmojiPlistName = @"expressionImage";
    
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.delegate = self;
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _contentLabel.isNeedAtAndPoundSign = YES;
    _contentLabel.disableEmoji = NO;
    _contentLabel.disableThreeCommon = YES;
    
    _contentLabel.lineSpacing = 3.0f;
    
    _contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    _contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _contentLabel.customEmojiPlistName = @"expressionImage";
    
    self.logoImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.logoImageView.layer.masksToBounds = YES;
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

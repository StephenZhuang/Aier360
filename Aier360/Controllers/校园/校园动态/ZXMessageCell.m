//
//  ZXMessageCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/23.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageCell.h"
#import "MagicalMacro.h"
#import "ZXTimeHelper.h"

@implementation ZXMessageCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.contentLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.contentLabel.isNeedAtAndPoundSign = YES;
    self.contentLabel.disableEmoji = NO;
    self.contentLabel.disableThreeCommon = YES;
    
    self.contentLabel.lineSpacing = 3.0f;
    
    self.contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    self.contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.contentLabel.customEmojiPlistName = @"expressionImage";
    
    self.dynamicImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.dynamicImageView.layer.masksToBounds = YES;
}

+ (CGFloat)heightForContent:(NSString *)content
{
    return [MLEmojiLabel heightForEmojiText:content preferredWidth:SCREEN_WIDTH-180 fontSize:14] + 39 + 17 + 26;
}

- (void)confirgureUIWithDynamicMessage:(ZXDynamicMessage *)dynamicMessage
{
    [self.headImageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:dynamicMessage.user.headimg] placeholderImage:[UIImage imageNamed:@"head_default"]];
    [self.nameLabel setText:dynamicMessage.user.nickname];
    if (dynamicMessage.type == 3) {
        [self.contentLabel setText:@"❤️"];
    } else {
        [self.contentLabel setText:dynamicMessage.content];
    }
    
    if (dynamicMessage.img.length > 0) {
        [self.dynamicContentLabel setHidden:YES];
        [self.dynamicImageView setHidden:NO];
        [self.dynamicImageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSmall:dynamicMessage.img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } else {
        [self.dynamicContentLabel setHidden:NO];
        [self.dynamicImageView setHidden:YES];
        [self.dynamicContentLabel setText:dynamicMessage.dynamicContent];
    }
    
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:dynamicMessage.cdate]];
}
@end

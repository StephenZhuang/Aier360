//
//  ZXDynamicCommentCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicCommentCell.h"
#import "MagicalMacro.h"
#import "ZXTimeHelper.h"

@implementation ZXDynamicCommentCell

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
    _emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _emojiLabel.isNeedAtAndPoundSign = YES;
    _emojiLabel.disableEmoji = NO;
    _emojiLabel.disableThreeCommon = YES;
    
    _emojiLabel.lineSpacing = 3.0f;
    
    _emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _emojiLabel.customEmojiPlistName = @"expressionImage";
}

#pragma mark - delegate
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

+ (CGFloat)heightByEmojiText:(NSString *)emojiText
{
    return MAX(65, [MLEmojiLabel heightForEmojiText:emojiText preferredWidth:(SCREEN_WIDTH - 82) fontSize:17] + 54);
}

- (void)configureUIWithDynamicComment:(ZXDynamicComment *)dynamicComment
{
    [self.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:dynamicComment.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.titleLabel setText:[NSString stringWithFormat:@"%@:",dynamicComment.nickname]];
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:dynamicComment.cdate]];
    _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _emojiLabel.customEmojiPlistName = @"expressionImage";
    [self.emojiLabel setText:dynamicComment.content];
}

- (void)configureUIWithDynamicCommentReply:(ZXDynamicCommentReply *)dynamicCommentReply
{
    [self.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:dynamicCommentReply.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:dynamicCommentReply.cdate]];
    _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _emojiLabel.customEmojiPlistName = @"expressionImage";
    [self.emojiLabel setText:dynamicCommentReply.content];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",dynamicCommentReply.nickname] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:74 green:74 blue:74],   NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@" 回复 " attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:131 green:131 blue:132],   NSFontAttributeName : [UIFont systemFontOfSize:17]}];
        NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",dynamicCommentReply.rname] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:74 green:74 blue:74],   NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    [string appendAttributedString:string2];
    [string appendAttributedString:string3];
    [self.titleLabel setAttributedText:string];
}

@end

//
//  ZXMailCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMailCell.h"
#import "MagicalMacro.h"
#import "ZXTimeHelper.h"

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
    [self.emojiView addSubview:self.emojiLabel];
}

- (MLEmojiLabel *)emojiLabel
{
    if (!_emojiLabel) {
        _emojiLabel = [MLEmojiLabel new];
        _emojiLabel.numberOfLines = 0;
        _emojiLabel.font = [UIFont systemFontOfSize:17.0f];
        _emojiLabel.delegate = self;
        _emojiLabel.backgroundColor = [UIColor clearColor];
        _emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _emojiLabel.isNeedAtAndPoundSign = YES;
        _emojiLabel.disableEmoji = NO;
        
        _emojiLabel.lineSpacing = 3.0f;
        
        _emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    }
    _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _emojiLabel.customEmojiPlistName = @"expressionImage";
    return _emojiLabel;
}

#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.emojiLabel.frame = _emojiView.bounds;
}

+ (CGFloat)heightByText:(NSString *)emojiText
{
    return [MLEmojiLabel heightForEmojiText:emojiText preferredWidth:(SCREEN_WIDTH - 30) fontSize:17] + 95;
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

- (void)configureUIWithSchoolMasterEmail:(ZXSchoolMasterEmail *)email indexPath:(NSIndexPath *)indexPath
{
    [self.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:email.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.titleLabel setText:email.nickname];
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:email.cdate]];
    [self.emojiLabel setText:email.content];
    [self.deleteButton setTag:indexPath.section];
}
@end

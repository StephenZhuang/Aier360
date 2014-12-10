//
//  ZXMailCommentCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMailCommentCell.h"
#import "MagicalMacro.h"

@implementation ZXMailCommentCell

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
        _emojiLabel.font = [UIFont systemFontOfSize:15];
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
    return [MLEmojiLabel heightForEmojiText:emojiText preferredWidth:(SCREEN_WIDTH - 54) fontSize:15] + 16;
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

- (void)configureUIWithSchoolMasterEmail:(ZXSchoolMasterEmailDetail *)email
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",[ZXUtils sharedInstance].currentSchool.name] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:102 green:199 blue:169],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:email.content attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:131 green:131 blue:132],   NSFontAttributeName : [UIFont systemFontOfSize:15]}];
    [string appendAttributedString:string2];
    [self.emojiLabel setText:string];
}
@end

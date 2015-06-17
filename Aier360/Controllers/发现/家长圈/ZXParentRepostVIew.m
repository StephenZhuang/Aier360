//
//  ZXParentRepostVIew.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/15.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXParentRepostVIew.h"
#import "MagicalMacro.h"
#import "ZXManagedUser.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>

@implementation ZXParentRepostVIew
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.emojiLabel.delegate = self;
    self.emojiLabel.backgroundColor = [UIColor clearColor];
    self.emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.emojiLabel.isNeedAtAndPoundSign = YES;
    self.emojiLabel.disableEmoji = NO;
    self.emojiLabel.disableThreeCommon = YES;
    
    self.emojiLabel.lineSpacing = 3.0f;
    
    self.emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    self.emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.emojiLabel.customEmojiPlistName = @"expressionImage";
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

- (void)configureWithDynamic:(ZXPersonalDynamic *)dynamic
{
    ZXManagedUser *user = dynamic.user;
    [self.nameLabel setText:user.nickname];
    
    if (dynamic) {
        [self.emojiLabel setText:dynamic.content];
    } else {
        [self.emojiLabel setText:@"原动态已被删除"];
    }
    
    if (dynamic.img.length > 0) {
        NSString *img = [[dynamic.img componentsSeparatedByString:@","] firstObject];
        [self.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForFresh:img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.imageView.fd_collapsed = NO;
        self.repostViewHeight.constant = 121;
    } else {
        self.imageView.fd_collapsed = YES;
        self.repostViewHeight.constant = 90;
    }
}
@end

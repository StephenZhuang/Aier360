//
//  ZXCollectionCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCollectionCell.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "ZXTimeHelper.h"

@implementation ZXCollectionCell
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
    
    self.contentImage.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.contentImage.layer.masksToBounds = YES;
    
    self.contentImage.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.contentImage.layer.masksToBounds = YES;
}

- (void)configureUIWithCollection:(ZXCollection *)collection
{
    [self.headImg sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:collection.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.nameLabel setText:collection.nickname];
    [self.emojiLabel setText:collection.content];
    if (collection.img.length > 0) {
        self.contentImage.fd_collapsed = NO;
        NSString *img = [[collection.img componentsSeparatedByString:@","] firstObject];
        [self.contentImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForFresh:img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } else {
        self.contentImage.fd_collapsed = YES;
    }
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:collection.ctime]];
}
@end

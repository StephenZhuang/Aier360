//
//  ZXHomeworkCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkCell.h"
#import "ZXTimeHelper.h"

@implementation ZXHomeworkCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configureUIWithHomework:(ZXHomework *)homework indexPath:(NSIndexPath *)indexPath
{
    [self.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:homework.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.titleLabel setText:homework.tname];
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:homework.cdate]];
    self.emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.emojiLabel.customEmojiPlistName = @"expressionImage";
    [self.emojiLabel setText:homework.content];
    [self.deleteButton setTag:indexPath.section];
}
@end

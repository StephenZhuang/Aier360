//
//  ZXSensitiveDynamicTableViewCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/15.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSensitiveDynamicTableViewCell.h"
#import "MagicalMacro.h"
#import "ZXTimeHelper.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>

@implementation ZXSensitiveDynamicTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.contentLabel.delegate = self;
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.contentLabel.isNeedAtAndPoundSign = NO;
    self.contentLabel.disableEmoji = NO;
    self.contentLabel.disableThreeCommon = YES;
    
    self.contentLabel.lineSpacing = 3.0f;
    self.contentLabel.numberOfLines = 2;
    self.contentLabel.textColor = [UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1.0];
    
    self.contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    self.contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.contentLabel.customEmojiPlistName = @"expressionImage";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithDynamic:(ZXPersonalDynamic *)dynamic
{
    ZXManagedUser *user = dynamic.user;
    [self.headImg sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    
    
    NSArray *sensitiveWords = [dynamic.sensitiveWords componentsSeparatedByString:@"$$"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:dynamic.content];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1.0] range:NSMakeRange(0, [dynamic.content length])];
    for (NSString *word in sensitiveWords) {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"%@",word] options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSArray *array = [regex matchesInString:dynamic.content options:0 range:NSMakeRange(0, [dynamic.content length])];
        if (array.count > 0) {
            for (NSTextCheckingResult *result in array) {
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
            }
        }
    }
    [self.contentLabel setText:string];
    self.contentHeight.constant = [MLEmojiLabel heightForEmojiText:dynamic.content preferredWidth:SCREEN_WIDTH-63 fontSize:14];
    
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:dynamic.cdate]];
    
    self.classLabel.fd_collapsed = NO;
    if (dynamic.type == 1) {
        [self.classLabel setText:@"校园动态"];
        [self.nameLabel setText:dynamic.tname];
    } else if (dynamic.type == 2) {
        [self.classLabel setText:[NSString stringWithFormat:@"%@动态",dynamic.cname]];
        [self.nameLabel setText:dynamic.tname];
    } else {
        [self.classLabel setText:@"个人动态"];
        [self.nameLabel setText:user.nickname];
    }
}

- (void)configureCellWithComment:(ZXDynamicComment *)comment
{
    [self.headImg sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:comment.headimg] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    [self.nameLabel setText:comment.nickname];
    
    NSArray *sensitiveWords = [comment.sensitiveWords componentsSeparatedByString:@"$$"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:comment.content];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1.0] range:NSMakeRange(0, [comment.content length])];
    for (NSString *word in sensitiveWords) {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"%@",word] options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSArray *array = [regex matchesInString:comment.content options:0 range:NSMakeRange(0, [comment.content length])];
        if (array.count > 0) {
            for (NSTextCheckingResult *result in array) {
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
            }
        }
    }
    [self.contentLabel setText:string];
    self.contentHeight.constant = [MLEmojiLabel heightForEmojiText:comment.content preferredWidth:SCREEN_WIDTH-63 fontSize:14];
    
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:comment.cdate]];
    
    self.classLabel.fd_collapsed = YES;
}
@end

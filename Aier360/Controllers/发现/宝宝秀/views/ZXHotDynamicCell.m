//
//  ZXHotDynamicCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHotDynamicCell.h"
#import "ZXManagedUser.h"

@implementation ZXHotDynamicCell

- (void)configureCellWithDynamic:(ZXPersonalDynamic *)dynamic
{
    [self.headButton sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:dynamic.user.headimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head_default"]];
    [self.nameLabel setText:dynamic.user.nickname];
    [self.addressLabel setText:dynamic.address];
    if (dynamic.img.length > 0) {
        NSString *imageUrl = [[dynamic.img componentsSeparatedByString:@","] firstObject];
        [self.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForFresh:imageUrl] placeholderImage:nil];
        [self.contentLabel setText:nil];
    } else {
        [self.imageView setImage:nil];
        [self.contentLabel setText:dynamic.content];
    }
    [self.favButton setTitle:[NSString stringWithFormat:@"%@",@(dynamic.pcount)] forState:UIControlStateNormal];
    [self.favButton setTitle:[NSString stringWithFormat:@"%@",@(dynamic.pcount)] forState:UIControlStateSelected];
    self.favButton.selected = dynamic.hasParise == 1;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.imageView.layer.masksToBounds = YES;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.mask.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,
                       (id)[UIColor colorWithRed:27/255.0 green:16/255.0 blue:10/255.0 alpha:1.0].CGColor,nil];
    [self.mask.layer insertSublayer:gradient atIndex:0];
    
    self.contentLabel.delegate = nil;
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.contentLabel.isNeedAtAndPoundSign = NO;
    self.contentLabel.disableEmoji = NO;
    self.contentLabel.disableThreeCommon = YES;
    
    self.contentLabel.lineSpacing = 3.0f;
    
    self.contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    self.contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.contentLabel.customEmojiPlistName = @"expressionImage";
}
@end

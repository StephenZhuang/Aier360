//
//  ZXShareMenuCollectionViewCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXShareMenuCollectionViewCell.h"

@implementation ZXShareMenuCollectionViewCell
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self.iconImage setHighlighted:highlighted];
}
@end

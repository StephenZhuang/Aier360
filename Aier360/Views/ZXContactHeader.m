//
//  ZXContactHeader.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXContactHeader.h"
#import <PureLayout/PureLayout.h>

@implementation ZXContactHeader


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.contentView.backgroundColor = [UIColor colorWithRed:247 green:245 blue:237];
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor colorWithRed:179 green:176 blue:168]];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
    }
    return _titleLabel;
}

@end

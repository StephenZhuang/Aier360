//
//  ZXBabyShownCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/21.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBabyShownCell.h"
#import "MagicalMacro.h"
#import "ZXTimeHelper.h"

@implementation ZXBabyShownCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.babyItemContentView removeFromSuperview];
    _babyItemContentView = nil;
}

- (void)setBabyList:(NSArray *)babyList
{
    _babyList = babyList;
    [self configureUI];
}

- (void)configureUI
{
    for (int i = 0; i < _babyList.count; i++) {
        ZXBaby *baby = _babyList[i];
        UIView *babyItem = [[UIView alloc] initWithFrame:CGRectMake(0, i * 20, 200, 20)];
        [self.babyItemContentView addSubview:babyItem];
        
        UIImageView *sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 13, 13)];
        if ([baby.sex isEqualToString:@"男"]) {
            [sexImage setImage:[UIImage imageNamed:@"mine_babysex_male"]];
        } else {
            [sexImage setImage:[UIImage imageNamed:@"mine_babysex_female"]];
        }
        [babyItem addSubview:sexImage];
        
        UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 150, 20)];
        [ageLabel setTextColor:[UIColor colorWithRed:95 green:95 blue:95]];
        [ageLabel setText:[ZXTimeHelper yearAndMonthSinceNow:baby.birthday]];
        [babyItem addSubview:ageLabel];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (UIView *)babyItemContentView
{
    if (!_babyItemContentView) {
        _babyItemContentView = [[UIView alloc] initWithFrame:CGRectMake(112, 12, SCREEN_WIDTH - 142, 20)];
        [self.contentView addSubview:_babyItemContentView];
    }
    return _babyItemContentView;
}
@end

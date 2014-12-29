//
//  ZXContactsCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 14/12/29.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXContactsCell.h"

@implementation ZXContactsCell
- (void)configreUIWithFollow:(ZXFollow *)follow
{
    [self.logoImage sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:follow.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self setSex:follow.sex age:follow.age];
    [self.titleLabel setText:follow.nickname];
    [self.addressLabel setText:follow.address];
}

- (void)setSex:(NSString *)sex age:(NSInteger)age
{
    [self.ageButton setTitle:[NSString stringWithIntger:age] forState:UIControlStateNormal];
    if ([sex isEqualToString:@"男"]) {
        [self.ageButton setImage:[UIImage imageNamed:@"user_sex_male"] forState:UIControlStateNormal];
        [self.ageButton setBackgroundColor:[UIColor colorWithRed:113 green:169 blue:219]];
    } else {
        [self.ageButton setImage:[UIImage imageNamed:@"user_sex_female"] forState:UIControlStateNormal];
        [self.ageButton setBackgroundColor:[UIColor colorWithRed:243 green:130 blue:198]];
    }
}
@end

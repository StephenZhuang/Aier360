//
//  ZXMenuCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMenuCell.h"

@implementation ZXMenuCell
- (void)awakeFromNib
{
    self.logoImage.layer.cornerRadius = 5;
    self.logoImage.layer.masksToBounds = YES;
    
    _hasNewLabel.layer.cornerRadius = 11;
    _hasNewLabel.layer.masksToBounds = YES;
}
@end

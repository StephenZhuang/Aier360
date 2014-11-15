//
//  ZXSelectCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/15.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSelectCell.h"

@implementation ZXSelectCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [_checkButton setSelected:selected];
    [_checkButton setUserInteractionEnabled:NO];
}
@end

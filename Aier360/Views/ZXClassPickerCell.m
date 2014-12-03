//
//  ZXClassPickerCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/3.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClassPickerCell.h"

@implementation ZXClassPickerCell
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithRed:32 green:196 blue:138];
        self.textLabel.textColor = [UIColor whiteColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor colorWithRed:96 green:96 blue:96];
    }
}
@end

//
//  ZXClassPickCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/17.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClassPickCell.h"

@implementation ZXClassPickCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}
@end

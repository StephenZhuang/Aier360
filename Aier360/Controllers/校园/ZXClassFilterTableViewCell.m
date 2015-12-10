//
//  ZXClassFilterTableViewCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/10.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXClassFilterTableViewCell.h"

@implementation ZXClassFilterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.imageLabel setHighlighted:selected];
    [self.imageIcon setHighlighted:selected];
    [self.favIcon setHighlighted:selected];
    [self.favLabel setHighlighted:selected];
    
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithRed:247/255.0 green:245/255.0 blue:237/255.0 alpha:1.0];
    } else {
        self.contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:248/255.0 alpha:1.0];
    }
}

- (void)configureCellWithClass:(ZXClass *)zxclass
{
    [self.titleLabel setText:zxclass.cname];
    [self.favLabel setText:zxclass.dynamicPraiseNumStr];
    [self.imageLabel setText:zxclass.dynamicNumStr];
}
@end

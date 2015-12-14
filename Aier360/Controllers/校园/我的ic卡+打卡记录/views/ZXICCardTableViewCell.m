//
//  ZXICCardTableViewCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/13.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXICCardTableViewCell.h"

@implementation ZXICCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    
}

- (void)configureCellWithCard:(ZXICCard *)card
{
//    [self setHighlighted:(card.state!=10) animated:YES];
    [self.cardNumLabel setText:card.cardnum];
    [self.codeLabel setText:[NSString stringWithFormat:@"%@",@(card.siid)]];
    [self.nameLabel setText:card.name_card];
    [self.jobLabel setText:card.gname];
    [self.schoolLabel setText:card.sname];
    
    BOOL highlighted = (card.state!=10);
    [self.cardNumLabel setHighlighted:highlighted];
    [self.codeLabel setHighlighted:highlighted];
    [self.nameLabel setHighlighted:highlighted];
    [self.jobLabel setHighlighted:highlighted];
    [self.schoolLabel setHighlighted:highlighted];
    [self.cardNumTitleLabel setHighlighted:highlighted];
    [self.codeTitleLabel setHighlighted:highlighted];
    [self.nameTitleLabel setHighlighted:highlighted];
    [self.jobTitleLabel setHighlighted:highlighted];
    [self.schoolTitleLabel setHighlighted:highlighted];
    if (highlighted) {
        [self.bgImage setImage:[[UIImage imageNamed:@"card_bg_d"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 70, 0, 30) resizingMode:UIImageResizingModeStretch]];
        [self.actionButton setImage:[UIImage imageNamed:@"card_bt_deleted"] forState:UIControlStateNormal];
    } else {
        [self.bgImage setImage:[[UIImage imageNamed:@"card_bg_n"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 70, 0, 30) resizingMode:UIImageResizingModeStretch]];
        [self.actionButton setImage:[UIImage imageNamed:@"card_bt_delete"] forState:UIControlStateNormal];
    }
}

@end

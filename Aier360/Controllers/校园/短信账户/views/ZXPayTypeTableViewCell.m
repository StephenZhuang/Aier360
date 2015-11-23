//
//  ZXPayTypeTableViewCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/23.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPayTypeTableViewCell.h"

@implementation ZXPayTypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.checkBox.onAnimationType = BEMAnimationTypeBounce;
    self.checkBox.offAnimationType = BEMAnimationTypeBounce;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.checkBox setOn:selected animated:YES];
}

@end

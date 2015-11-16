//
//  ZXMessageRecordTableViewCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/16.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageRecordTableViewCell.h"

@implementation ZXMessageRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureUIWithMessageRecord:(ZXMessageRecord *)messageRecord
{
    [self.titleLabel setText:messageRecord.descript];
    NSLog(@"%@",messageRecord.descript);
    [self.timeLabel setText:messageRecord.cdateStr];
    [self.numLabel setText:[NSString stringWithFormat:@"+%@",@(messageRecord.num)]];
    [self.nameLabel setText:messageRecord.nickname];
}
@end

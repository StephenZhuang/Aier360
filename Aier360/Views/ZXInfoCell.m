//
//  ZXInfoCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXInfoCell.h"

@implementation ZXInfoCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configureUIWithUser:(ZXUser *)user title:(NSString *)title indexPath:(NSIndexPath *)indexPath
{
    [self.titleLabel setText:title];
    switch (indexPath.row) {
        case 0:
            [self.contentLabel setText:user.nickname];
            break;
        case 1:
            [self.contentLabel setText:user.desinfo];
            break;
        case 2:
            [self.contentLabel setText:user.sex];
            break;
        case 3:
            [self.contentLabel setText:[[user.birthday componentsSeparatedByString:@"T"] firstObject]];
            break;
        case 4:
            [self.contentLabel setText:user.industry];
            break;
        case 5:
            [self.contentLabel setText:user.city];
            break;
        case 6:
            [self.contentLabel setText:user.ht];
            break;
        default:
            break;
    }
}

@end

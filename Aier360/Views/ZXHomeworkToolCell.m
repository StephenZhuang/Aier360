//
//  ZXHomeworkToolCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHomeworkToolCell.h"

@implementation ZXHomeworkToolCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configureUIWithHomework:(ZXHomework *)homework indexPath:(NSIndexPath *)indexPath
{
    [self.praiseButton setTitle:[NSString stringWithIntger:homework.reading] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithIntger:homework.comment] forState:UIControlStateNormal];
    self.praiseButton.tag = indexPath.section;
    self.commentButton.tag = indexPath.section;
    
}
@end

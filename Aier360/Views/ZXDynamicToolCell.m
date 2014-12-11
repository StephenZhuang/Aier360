//
//  ZXDynamicToolCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDynamicToolCell.h"

@implementation ZXDynamicToolCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)configureUIWithDynamic:(ZXDynamic *)dynamic indexPath:(NSIndexPath *)indexPath
{
    [_praiseButton setTitle:[NSString stringWithIntger:dynamic.pcount] forState:UIControlStateNormal];
    [_praiseButton setSelected:dynamic.pflag];
    [_repostButton setTitle:[NSString stringWithIntger:dynamic.tcount] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithIntger:dynamic.ccount] forState:UIControlStateNormal];
    _praiseButton.tag = indexPath.section;
    _repostButton.tag = indexPath.section;
    _commentButton.tag = indexPath.section;
    
}
@end

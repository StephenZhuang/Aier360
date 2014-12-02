//
//  ZXDropTitleView.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/2.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXDropTitleView.h"

@implementation ZXDropTitleView
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [UIView animateWithDuration:0.25 animations:^(void) {        
        if (selected) {
            self.imageView.layer.transform = CATransform3DRotate(self.imageView.layer.transform, M_PI, 1, 0, 0);
        } else {
            self.imageView.layer.transform = CATransform3DIdentity;
        }
    }];
}
@end

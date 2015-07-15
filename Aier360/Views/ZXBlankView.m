//
//  ZXBlankView.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/7/15.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBlankView.h"

@implementation ZXBlankView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configureWithImage:(UIImage *)image text:(NSString *)text
{
    [self.imageView setImage:image];
    [self.label setText:text];
}
@end

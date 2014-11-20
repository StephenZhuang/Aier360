//
//  ZXReadHeader.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXReadHeader.h"

@implementation ZXReadHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleState)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    _state = ZXReadHeaderStateOn;
}

- (void)setState:(ZXReadHeaderState)state
{
    _state = state;
    if (_toggleBlock) {
        _toggleBlock(state);
    }
}

- (void)toggleState
{
    if (_state == ZXReadHeaderStateOn) {
        [self setState:ZXReadHeaderStateOff];
        
        [UIView animateWithDuration:0.25 animations:^(void) {
            _arrowImage.transform = CGAffineTransformRotate(self.transform, -M_PI_2);
        }];
    } else {
        [self setState:ZXReadHeaderStateOn];
        [UIView animateWithDuration:0.25 animations:^(void) {
            _arrowImage.transform = CGAffineTransformIdentity;
        }];
    }
}


@end

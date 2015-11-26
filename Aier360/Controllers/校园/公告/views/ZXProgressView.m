//
//  ZXProgressView.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/13.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXProgressView.h"

#define MIN_WIDTH 22

@implementation ZXProgressView
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    self.trackImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.trackImageView];
    
    self.progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MIN_WIDTH, self.frame.size.height)];
    [self addSubview:self.progressImageView];
}

- (void)setProgressImage:(UIImage *)progressImage
{
    _progressImage = progressImage;
    self.progressImageView.image = progressImage;
}

- (void)setTrackImage:(UIImage *)trackImage
{
    _trackImage = trackImage;
    self.trackImageView.image = trackImage;
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    _progress = progress;
    if (animated) {
        [UIView animateWithDuration:MIN(1, progress) animations:^{
            CGFloat width = self.frame.size.width * MIN(1, progress);
            if (progress == 0) {
                width = 0;
            } else {
                width = MAX(width, MIN_WIDTH);
            }
            [self.progressImageView setFrame:CGRectMake(0, 0, width, self.frame.size.height)];
        }];
    } else {
        CGFloat width = self.frame.size.width * MIN(1, progress);
        if (progress == 0) {
            width = 0;
        } else {
            width = MAX(width, MIN_WIDTH);
        }
        [self.progressImageView setFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    }
}
@end

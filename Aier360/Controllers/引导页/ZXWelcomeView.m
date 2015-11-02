//
//  ZXWelcomeView.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/2.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXWelcomeView.h"
#import "MagicalMacro.h"

@implementation ZXWelcomeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    self.backgroundColor = [UIColor colorWithRed:247 green:245 blue:237];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setContentSize:CGSizeMake(4 * self.frame.size.width, self.frame.size.height)];
    
    for (int i = 0; i < 4; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"welcome_0%@",@(i+1)] ofType:@"jpg"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
        [scrollView addSubview:imageView];
    }
    
    [self addSubview:scrollView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((SCREEN_WIDTH-191)/2, SCREEN_HEIGHT-50-38, 191, 38);
    [button setBackgroundImage:[UIImage imageNamed:@"welcome_dismiss"] forState:UIControlStateNormal];
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [button addTarget:self action:@selector(dismissWelcome) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)dismissWelcome
{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

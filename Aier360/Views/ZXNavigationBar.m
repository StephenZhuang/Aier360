//
//  ZXNavigationBar.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXNavigationBar.h"

@implementation ZXNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [self setBarTintColor:[UIColor colorWithRed:4 green:192 blue:143]];
    NSDictionary* attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self setTitleTextAttributes:attrs];
    [self setTintColor:[UIColor whiteColor]];
    if(IOS8_OR_LATER && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [self setTranslucent:NO];
    }
}

@end

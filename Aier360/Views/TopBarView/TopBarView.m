//
//  TopBarView.m
//  Property
//
//  Created by admin on 13-11-28.
//  Copyright (c) 2013年 lijun. All rights reserved.
//

#import "TopBarView.h"
#define ButtonWidth 80

@implementation TopBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    _selectedIndex = [_dataSource defaultSelectedItem];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar_bg"]];
    [backgroundImageView setFrame:self.bounds];
    [self addSubview:backgroundImageView];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:mScrollView];
    [mScrollView setShowsHorizontalScrollIndicator:NO];
    [mScrollView setContentSize:CGSizeMake(ButtonWidth * [_dataSource numOfItems], CGRectGetHeight(self.frame))];
    
    
    int itemCount = [_dataSource numOfItems];
    CGFloat buttonWidth = self.frame.size.width / itemCount;
//    CGFloat buttonWidth = ButtonWidth;
    
    selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kong"]];
    [selectedImage setFrame:CGRectMake(0, 0, buttonWidth, self.frame.size.height)];
    [mScrollView addSubview:selectedImage];
    
    
    buttonArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< itemCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, self.frame.size.height)];
        
        NSString *title = [_dataSource topBarView:self nameForItem:i];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateHighlighted];
        
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [button setTitleColor:[UIColor colorWithRed:132 green:132 blue:134] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:21 green:204 blue:156] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithRed:21 green:204 blue:156] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == [_dataSource defaultSelectedItem]) {
            [button setSelected:YES];
        }
        
        [mScrollView addSubview:button];
        
        [buttonArray addObject:button];
    }
}

- (void)buttonAction:(id)sender
{

    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 2) {
        button.tag = 3;
        [self btnAction:button];
    } else if (button.tag == 3) {
        button.tag = 2;
        [self btnAction:button];
    } else {
        if (!button.selected) {
            [self btnAction:button];
        }
    }
    
}

- (void)btnAction:(UIButton *)button
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        [selectedImage setFrame:button.frame];
    }];
    
    for (UIButton *btn in buttonArray) {
        [btn setSelected:NO];
    }
    
    [button setSelected:YES];
    _selectedIndex = button.tag;
    [_delegate selectItemAtIndex:button.tag];
}

- (void)reloadData
{
    [mScrollView removeFromSuperview];
    
    [self drawRect:self.bounds];
}

@end

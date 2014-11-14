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
//    [backgroundImageView release];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:mScrollView];
    [mScrollView setShowsHorizontalScrollIndicator:NO];
    [mScrollView setContentSize:CGSizeMake(ButtonWidth * [_dataSource numOfItems], CGRectGetHeight(self.frame))];
    
    
    int itemCount = [_dataSource numOfItems];
//    CGFloat buttonWidth = self.frame.size.width / itemCount;
    CGFloat buttonWidth = ButtonWidth;
    
    selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar_select"]];
    [selectedImage setFrame:CGRectMake(0, 0, buttonWidth, self.frame.size.height)];
    [mScrollView addSubview:selectedImage];
    
    
    buttonArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< itemCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 1;
        if (i > 0) {
            button.tag = i + 2;
        }
        [button setFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, self.frame.size.height)];
        
        NSString *title = [_dataSource topBarView:self nameForItem:i];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateHighlighted];
        
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
//        [button setTitleColor:RGB(86, 86, 86) forState:UIControlStateNormal];
//        [button setTitleColor:RGB(86, 86, 86) forState:UIControlStateHighlighted];
//        [button setTitleColor:RGB(86, 86, 86) forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
//    [buttonArray release];
//    [selectedImage release];
//    [mScrollView release];
    
    [self drawRect:self.bounds];
}

//- (void)dealloc
//{
//    [buttonArray release];
//    [selectedImage release];
//    [mScrollView release];
//    [super dealloc];
//}

@end

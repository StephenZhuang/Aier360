//
//  TopBarView.m
//  Property
//
//  Created by admin on 13-11-28.
//  Copyright (c) 2013年 lijun. All rights reserved.
//

#import "TopBarView.h"
#define ButtonWidth 58

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
    if (!mScrollView) {
        
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowRadius = 5.0;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOpacity = 0.8;
        _selectedIndex = [_dataSource defaultSelectedItem];
        
        //    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_toolbar"]];
        //    [backgroundImageView setFrame:self.bounds];
        //    [self addSubview:backgroundImageView];
        //    [backgroundImageView release];
        
        mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:mScrollView];
        [mScrollView setShowsHorizontalScrollIndicator:NO];
        [mScrollView setContentSize:CGSizeMake(ButtonWidth * [_dataSource numOfItems] + 12, CGRectGetHeight(self.frame))];
        [mScrollView setScrollEnabled:NO];
        
        
        NSInteger itemCount = [_dataSource numOfItems];
        //    CGFloat buttonWidth = self.frame.size.width / itemCount;
        CGFloat buttonWidth = ButtonWidth;
        
        selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_toolbar"]];
        [selectedImage setFrame:CGRectMake(12, 0, buttonWidth, self.frame.size.height)];
        [mScrollView addSubview:selectedImage];
        
        
        buttonArray = [[NSMutableArray alloc] init];
        for (int i = 0; i< itemCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            [button setFrame:CGRectMake(12+i * buttonWidth, 0, buttonWidth, self.frame.size.height)];
            
            NSString *title = [_dataSource topBarView:self nameForItem:i];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateSelected];
            [button setTitle:title forState:UIControlStateHighlighted];
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
            [button setTitleColor:[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:4/255.0 green:192/255.0 blue:143/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor colorWithRed:4/255.0 green:192/255.0 blue:143/255.0 alpha:1.0] forState:UIControlStateSelected];
            
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == [_dataSource defaultSelectedItem]) {
                [button setSelected:YES];
            }
            
            [mScrollView addSubview:button];
            
            [buttonArray addObject:button];
        }
    }
}

- (void)buttonAction:(id)sender
{

    UIButton *button = (UIButton *)sender;
    
    if (!button.selected) {
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
    
}

- (void)reloadData
{
    [mScrollView removeFromSuperview];
    mScrollView = nil;
    
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

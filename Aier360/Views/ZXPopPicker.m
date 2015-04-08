//
//  ZXPopPicker.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/20.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPopPicker.h"
#import "MagicalMacro.h"
#import <pop/POP.h>

#define Picker_MAX_Width (0.72 * SCREEN_WIDTH)
#define Picker_MAX_Height (0.6 * SCREEN_HEIGHT)

@implementation ZXPopPicker
- (instancetype)initWithTitle:(NSString *)title contents:(NSArray *)contents
{
    self = [super init];
    if (self) {
        _pickTitle = title;
        _dataArray = contents;
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    canHide = NO;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    _maskView = [[UIView alloc] init];
    _maskView.frame = self.bounds;
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.5;
    [self addSubview:_maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_maskView addGestureRecognizer:tap];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Picker_MAX_Width, MIN(48 * _dataArray.count + 55, Picker_MAX_Height))];
    _tableView.center = self.center;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView setSeparatorColor:[UIColor colorWithRed:210 green:207 blue:195]];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.layer.cornerRadius = 5;
    _tableView.layer.masksToBounds = YES;
    [_tableView setBackgroundColor:[UIColor colorWithRed:255 green:252 blue:248]];
    [self addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Picker_MAX_Width, 55)];
    [headerView setBackgroundColor:[UIColor colorWithRed:255 green:252 blue:248]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 53, Picker_MAX_Width, 2)];
    [lineView setBackgroundColor:[UIColor colorWithRed:4 green:192 blue:143]];
    [headerView addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, Picker_MAX_Width - 40, 30)];
    [titleLabel setText:_pickTitle];
    [titleLabel setTextColor:[UIColor colorWithRed:4 green:192 blue:143]];
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    [headerView addSubview:titleLabel];
    
    _tableView.tableHeaderView = headerView;
    
    [self showPopup];
}

#pragma -mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:_dataArray[indexPath.row]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:95 green:95 blue:95]];
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:255 green:252 blue:248]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_ZXPopPickerBlock) {
        _ZXPopPickerBlock(indexPath.row);
    }
    [self hide];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma  -mark
- (void)hide
{
    [self hidePopup];
}

- (void)showPopup
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0.5, 0.5f)];
    scaleAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];//@(0.0f);
    scaleAnimation.springBounciness = 20.0f;
    scaleAnimation.springSpeed = 20.0f;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            canHide = YES;
        }
    };
    [_tableView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)hidePopup
{
    if (!canHide) {
        return;
    }
    canHide = NO;
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(1);
    opacityAnimation.toValue = @(0);
    [_tableView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
    scaleAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    };
    [_tableView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}
@end

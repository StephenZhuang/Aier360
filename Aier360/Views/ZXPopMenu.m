//
//  ZXPopMenu.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPopMenu.h"
#import <pop/POP.h>

@implementation ZXPopMenu
- (instancetype)initWithContents:(NSArray *)contents
{
    self = [super init];
    if (self) {
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
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 123, 40 * _dataArray.count)];
    _tableView.center = self.center;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView setSeparatorColor:[UIColor colorWithRed:239 green:236 blue:223]];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.layer.cornerRadius = 5;
    _tableView.layer.masksToBounds = YES;
    [_tableView setBackgroundColor:[UIColor colorWithRed:247 green:245 blue:237]];
    [self addSubview:_tableView];
    
    [self showPopup];
}

#pragma mark-
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
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.textLabel setText:_dataArray[indexPath.row]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:95 green:95 blue:95]];
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:247 green:245 blue:237]];
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

#pragma  mark-
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

//
//  ZXPopMenu.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXPopMenu.h"
#import <pop/POP.h>
#import "MagicalMacro.h"

@implementation ZXPopMenu
- (instancetype)initWithContents:(NSArray *)contents targetFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _dataArray = contents;
        [self configureUIWithTargetFrame:frame];
    }
    return self;
}

- (void)configureUIWithTargetFrame:(CGRect)frame
{
    canHide = NO;
    _showing = NO;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    [_maskView setBackgroundColor:[UIColor clearColor]];
    [_maskView addGestureRecognizer:tap];
    [self addSubview:_maskView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-140, CGRectGetMaxY(frame), 140, 40 * _dataArray.count)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView setSeparatorColor:[UIColor colorWithRed:239 green:236 blue:223]];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    _tableView.layer.cornerRadius = 5;
    _tableView.layer.masksToBounds = YES;
    _tableView.scrollEnabled = NO;
    [_tableView setBackgroundColor:[UIColor colorWithRed:247 green:245 blue:237]];
    
    _tableView.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
    _tableView.layer.shadowOffset = CGSizeMake(4, 4);//偏移距离
    _tableView.layer.shadowOpacity = 0.5;//不透明度
    _tableView.layer.shadowRadius = 2.0;//半径
    
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
    if (canHide) {        
        if (_ZXPopPickerBlock) {
            _ZXPopPickerBlock(indexPath.row);
        }
        [self hide];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma  mark-
- (void)hide
{
    [self hidePopup];
}

- (void)showPopup
{
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue = @(1);
    opacityAnimation.beginTime = CACurrentMediaTime() + 0.1;
    [_tableView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    CGFloat width = 140;
    CGFloat height = 40 * _dataArray.count;
    
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewBounds];
    sizeAnimation.fromValue  = [NSValue valueWithCGRect:CGRectMake(width/2, height, width/2, height/2)];
    sizeAnimation.toValue  = [NSValue valueWithCGRect:CGRectMake(width, height, width, height)];
    sizeAnimation.springBounciness = 20.0f;
    sizeAnimation.springSpeed = 40.0f;
    sizeAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            canHide = YES;
            _showing = YES;
        }
    };
    [_tableView pop_addAnimation:sizeAnimation forKey:@"sizeAnimation"];
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
    
    
//    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    
//    scaleAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
//    scaleAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
//    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//        if (finished) {
//            _showing = NO;
//            [self removeFromSuperview];
//        }
//    };
//    [_tableView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    CGFloat width = 140;
    CGFloat height = 40 * _dataArray.count;
    
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewBounds];
    sizeAnimation.fromValue  = [NSValue valueWithCGRect:CGRectMake(width, height, width, height)];
    sizeAnimation.toValue  = [NSValue valueWithCGRect:CGRectMake(width/2, height, width/2, height/2)];
    sizeAnimation.springBounciness = 20.0f;
    sizeAnimation.springSpeed = 20.0f;
    sizeAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            _showing = NO;
            [self removeFromSuperview];
        }
    };
    [_tableView pop_addAnimation:sizeAnimation forKey:@"sizeAnimation"];
}
@end

//
//  ZXRepostActionSheet.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRepostActionSheet.h"

@implementation ZXRepostActionSheet


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, 0, - CGRectGetHeight(self.frame));
    }];
    if (_identity == ZXIdentitySchoolMaster) {
        [self.label setText:@"学校动态"];
        [self.image setImage:[UIImage imageNamed:@"ic_repost_school"]];
    } else if (_identity == ZXIdentityClassMaster) {
        [self.label setText:@"班级动态"];
        [self.image setImage:[UIImage imageNamed:@"ic_repost_class"]];
    }
 
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    _userView.userInteractionEnabled = YES;
    [_userView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    _otherView.userInteractionEnabled = YES;
    [_otherView addGestureRecognizer:tap1];
}

- (void)addMaskInView:(UIView *)view
{
    _mask = [[UIView alloc] initWithFrame:view.bounds];
    _mask.backgroundColor = [UIColor blackColor];
    _mask.alpha = 0.3;
    [view insertSubview:_mask belowSubview:self];
    _mask.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_mask addGestureRecognizer:tap];
}

- (IBAction)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
        _mask.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_mask removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)clickAction:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    if (_clickBlock) {
        _clickBlock(view.tag);
    }
    [self hide];
}

+ (instancetype)showInView:(UIView *)view type:(ZXIdentity)type block:(void(^)(NSInteger index))block
{
    ZXRepostActionSheet *actionSheet = [[[NSBundle mainBundle] loadNibNamed:@"ZXRepostActionSheet" owner:self options:nil] firstObject];
    actionSheet.frame = CGRectMake(0, CGRectGetHeight(view.frame), CGRectGetWidth(view.frame), 173);
    actionSheet.identity = type;
    actionSheet.clickBlock = block;
    [view addSubview:actionSheet];
    [actionSheet addMaskInView:view];
    return actionSheet;
}

@end

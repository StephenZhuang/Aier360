//
//  ZXRepostActionSheet.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXRepostActionSheet : UIView
@property (nonatomic , weak) IBOutlet UIView *userView;
@property (nonatomic , weak) IBOutlet UIView *otherView;
@property (nonatomic , weak) IBOutlet UIImageView *image;
@property (nonatomic , weak) IBOutlet UILabel *label;
@property (nonatomic , strong) UIView *mask;
@property (nonatomic , assign) ZXIdentity identity;
@property (nonatomic , copy) void (^clickBlock)(NSInteger index);
+ (instancetype)showInView:(UIView *)view type:(ZXIdentity)type block:(void(^)(NSInteger index))block;
@end

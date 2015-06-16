//
//  ZXUserToolView.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXUserToolView : UIView
@property (nonatomic , strong) UIButton *chatButton;
@property (nonatomic , strong) UIButton *addFriendButton;
@property (nonatomic , assign) BOOL isFriend;

@property (nonatomic , copy) void (^chatBlock)();
@property (nonatomic , copy) void (^addFriendBlock)();

- (instancetype)initWithIsFriend:(BOOL)isFriend;
@end

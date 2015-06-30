//
//  ZXUserToolView.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXUserToolView.h"
#import "MagicalMacro.h"

@implementation ZXUserToolView
- (instancetype)initWithIsFriend:(BOOL)isFriend
{
    self = [super init];
    if (self) {
        [self configureUI];
        self.isFriend = isFriend;
    }
    return self;
}

- (void)configureUI
{
    [self addSubview:self.chatButton];
    [self addSubview:self.addFriendButton];
    self.frame = CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_bg"]];
}

- (UIButton *)chatButton
{
    if (!_chatButton) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = (SCREEN_WIDTH - 36) / 2;
        [_chatButton setFrame:CGRectMake(15, 6, width, 38)];
        [_chatButton setTitle:@"对话" forState:UIControlStateNormal];
        [_chatButton setTitleColor:[UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_chatButton setBackgroundImage:[[UIImage imageNamed:@"bt_user_chat"] stretchableImageWithLeftCapWidth:18 topCapHeight:9] forState:UIControlStateNormal];
        [_chatButton addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setImage:[UIImage imageNamed:@"mine_ic_chat"] forState:UIControlStateNormal];
    }
    return _chatButton;
}

- (UIButton *)addFriendButton
{
    if (!_addFriendButton) {
        _addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = (SCREEN_WIDTH - 36) / 2;
        [_addFriendButton setFrame:CGRectMake(21+width, 6, width, 38)];
        [_addFriendButton setTitle:@"加好友" forState:UIControlStateNormal];
        [_addFriendButton setTitleColor:[UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_addFriendButton setBackgroundImage:[[UIImage imageNamed:@"bt_user_chat"] stretchableImageWithLeftCapWidth:18 topCapHeight:9] forState:UIControlStateNormal];
        [_addFriendButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        [_addFriendButton setImage:[UIImage imageNamed:@"mine_ic_addfriend"] forState:UIControlStateNormal];
    }
    return _addFriendButton;
}

- (void)setIsFriend:(BOOL)isFriend
{
    _isFriend = isFriend;
    
    if (isFriend) {
        [UIView animateWithDuration:0.2 animations:^{
            self.addFriendButton.alpha = 0;
            self.chatButton.frame = CGRectMake(15, 6, SCREEN_WIDTH - 30, 38);
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.addFriendButton.alpha = 1;
            self.chatButton.frame = CGRectMake(15, 6, (SCREEN_WIDTH - 36) / 2, 38);
        }];
    }
}

- (void)chat
{
    !_chatBlock?:_chatBlock();
}

- (void)addFriend
{
    !_addFriendBlock?:_addFriendBlock();
}
@end

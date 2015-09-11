//
//  ZXCommentViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/25.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXEmojiPicker.h"
#import "ZXCommentToolBar.h"

@interface ZXCommentViewController : ZXBaseViewController
@property (nonatomic , assign) long did;
@property (nonatomic , weak) IBOutlet ZXCommentToolBar *commentToolBar;
@property (nonatomic , weak) IBOutlet ZXEmojiPicker *emojiPicker;
@property (nonatomic , assign) NSInteger type;

@property (nonatomic , assign) BOOL isReply;
@property (nonatomic , assign) long dcid;
@property (nonatomic , assign) long touid;
@property (nonatomic , copy) NSString *rname;
@property (nonatomic , copy) void (^commentBlock)();
@end

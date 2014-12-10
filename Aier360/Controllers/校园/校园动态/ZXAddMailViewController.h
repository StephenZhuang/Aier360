//
//  ZXAddMailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXEmojiPicker.h"
#import "UIPlaceHolderTextView.h"
#import "ZXSchoolMasterEmail+ZXclient.h"

@interface ZXAddMailViewController : ZXBaseViewController<UITextViewDelegate>
@property (nonatomic , weak) IBOutlet UIPlaceHolderTextView *textView;
@property (nonatomic , weak) IBOutlet ZXEmojiPicker *emojiPicker;
@property (nonatomic , weak) IBOutlet UIButton *emojiButton;
@property (nonatomic , strong) ZXSchoolMasterEmail *email;
@property (nonatomic , copy) void (^commentSuccess)();
@end

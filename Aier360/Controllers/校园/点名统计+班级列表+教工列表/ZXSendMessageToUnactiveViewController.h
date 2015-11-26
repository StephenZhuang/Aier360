//
//  ZXSendMessageToUnactiveViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/17.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXSendMessageToUnactiveViewController : ZXBaseViewController<UITextViewDelegate>
@property (nonatomic , copy) NSString *content;
@property (nonatomic , assign) long cid;
@property (nonatomic , weak) IBOutlet UITextView *textView;
@property (nonatomic , copy) void (^sendSuccess)();
@end

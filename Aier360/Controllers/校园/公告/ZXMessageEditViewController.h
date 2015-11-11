//
//  ZXMessageEditViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/10.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXAnnounceMessage.h"

@interface ZXMessageEditViewController : ZXBaseViewController<UITextViewDelegate>
@property (nonatomic , weak) IBOutlet UITextView *textView;
@property (nonatomic , weak) IBOutlet UILabel *letterNumLabel;
@property (nonatomic , weak) IBOutlet UILabel *messageNumLabel;

@property (nonatomic , strong) ZXAnnounceMessage *announceMessage;
@end

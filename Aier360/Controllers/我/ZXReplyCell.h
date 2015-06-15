//
//  ZXReplyCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel+ZXAddition.h"

@interface ZXReplyCell : UITableViewCell<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@end

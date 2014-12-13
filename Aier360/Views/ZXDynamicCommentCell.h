//
//  ZXDynamicCommentCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXDynamic.h"

@interface ZXDynamicCommentCell : ZXBaseCell<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
+ (CGFloat)heightByEmojiText:(NSString *)emojiText;
- (void)configureUIWithDynamicComment:(ZXDynamicComment *)dynamicComment;
- (void)configureUIWithDynamicCommentReply:(ZXDynamicCommentReply *)dynamicCommentReply;
@end

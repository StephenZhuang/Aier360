//
//  ZXReplyCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXReplyCell.h"

@implementation ZXReplyCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.emojiLabel.backgroundColor = [UIColor clearColor];
    self.emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.emojiLabel.isNeedAtAndPoundSign = YES;
    self.emojiLabel.disableEmoji = NO;
    self.emojiLabel.disableThreeCommon = NO;
    
    self.emojiLabel.lineSpacing = 3.0f;
    
    self.emojiLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    self.emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    self.emojiLabel.customEmojiPlistName = @"expressionImage";
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(deleteReply:) && _canDelete) {
        return YES;
    }
    return NO;
}

- (void)longPressReply:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        ZXReplyCell *cell = (ZXReplyCell *)recognizer.view;

        [cell becomeFirstResponder];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(deleteReply:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:deleteItem, nil]];
        [menu setTargetRect:cell.frame inView:cell.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)deleteReply:(id)sender
{
//    ZXDynamicCommentReply *reply = self.dynamicComment.dcrList[self.selectedIndex];
//    !_deleteCommentBlock?:_deleteCommentBlock(NO,reply.dcrid);
    !_longPressBlock?:_longPressBlock();
}

- (UILongPressGestureRecognizer *)replyLongPress
{
    if (!_replyLongPress) {
        _replyLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressReply:)];
    }
    return _replyLongPress;
}
@end

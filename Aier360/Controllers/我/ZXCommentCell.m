//
//  ZXCommentCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXCommentCell.h"
#import "ZXReplyCell.h"
#import "MagicalMacro.h"
#import "ZXTimeHelper.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import "ZXApiClient.h"

@implementation ZXCommentCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.emojiLabel.backgroundColor = [UIColor clearColor];
    self.emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.emojiLabel.isNeedAtAndPoundSign = YES;
    self.emojiLabel.disableEmoji = NO;
    self.emojiLabel.disableThreeCommon = YES;
    
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
    if (action == @selector(deleteComment:)) {
        return YES;
    }
    return NO;
}

- (void)longPressComment:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        ZXCommentCell *cell = (ZXCommentCell *)recognizer.view;
        [cell becomeFirstResponder];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(deleteComment:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:deleteItem, nil]];
        [menu setTargetRect:cell.frame inView:cell.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}



- (void)deleteComment:(id)sender
{
    !_deleteCommentBlock?:_deleteCommentBlock(YES,self.dynamicComment.did);
}



- (void)configureUI
{
    [self.headButton sd_setBackgroundImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:self.dynamicComment.headimg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.headButton addTarget:self action:@selector(headImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.nameLabel setText:self.dynamicComment.nickname];
    [self.timeLabel setText:[ZXTimeHelper intervalSinceNow:self.dynamicComment.cdate]];
    [self.emojiLabel setText:self.dynamicComment.content];
    self.emojiLabelHeight.constant = [MLEmojiLabel heightForEmojiText:self.dynamicComment.content preferredWidth:self.emojiLabel.frame.size.width fontSize:17];
    
    if (self.dynamicComment.dcrList.count > 0) {
        self.replyView.fd_collapsed = NO;
        [self.replyBg setImage:[[UIImage imageNamed:@"dynamic_bg_reply"] stretchableImageWithLeftCapWidth:25 topCapHeight:25]];
        [self.tableView reloadData];
        self.replyViewHeight.constant = self.tableView.contentSize.height + 16;
        self.tableViewHeight.constant = self.tableView.contentSize.height;
        
    } else {
        self.replyView.fd_collapsed = YES;
    }
    
    if (self.hasSuperDeleteRule || self.dynamicComment.uid == GLOBAL_UID) {
        [self addGestureRecognizer:self.commentLongPress];
    } else {
        [self removeGestureRecognizer:self.commentLongPress];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dynamicComment.dcrList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDynamicCommentReply *reply = self.dynamicComment.dcrList[indexPath.row];
    return [MLEmojiLabel heightForEmojiText:[NSString stringWithFormat:@"%@ 回复 %@:%@",reply.nickname,reply.rname,reply.content] preferredWidth:SCREEN_WIDTH-107 fontSize:17]+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak ZXReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXReplyCell"];
    ZXDynamicCommentReply *reply = self.dynamicComment.dcrList[indexPath.row];
    [cell.emojiLabel setText:[NSString stringWithFormat:@"%@ 回复 %@:%@",reply.nickname,reply.rname,reply.content]];
    [cell.emojiLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.aierbon.com/getuid.shtml?uid=%@",@(reply.uid)]] withRange:[cell.emojiLabel.text rangeOfString:reply.nickname]];
    [cell.emojiLabel addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.aierbon.com/getuid.shtml?uid=%@",@(reply.ruid)]] withRange:[cell.emojiLabel.text rangeOfString:reply.rname]];
    cell.emojiLabel.delegate = self;
    
    cell.canDelete = (self.hasSuperDeleteRule || reply.uid == GLOBAL_UID);
    [cell addGestureRecognizer:cell.replyLongPress];
//    if (self.hasSuperDeleteRule || reply.uid == GLOBAL_UID) {
//    } else {
//        [cell removeGestureRecognizer:cell.replyLongPress];
//    }
    cell.longPressBlock = ^(void) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ZXDynamicCommentReply *reply = self.dynamicComment.dcrList[indexPath.row];
        !_deleteCommentBlock?:_deleteCommentBlock(NO,reply.dcrid);
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDynamicCommentReply *reply = self.dynamicComment.dcrList[indexPath.row];
    !_replyBlock?:_replyBlock(reply);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
        {
            NSLog(@"点击了链接%@",link);
            NSString *string = @"http://www.aierbon.com/getuid.shtml?uid=";
            if ([link hasPrefix:string]) {
                long uid = [[link substringFromIndex:string.length] integerValue];
                !_userBlock?:_userBlock(uid);
            }
        }
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
}

- (IBAction)headImageAction:(id)sender
{
    !_userBlock?:_userBlock(self.dynamicComment.uid);
}

#pragma mark - setters and getters
- (void)setDynamicComment:(ZXDynamicComment *)dynamicComment
{
    _dynamicComment = dynamicComment;
    [self configureUI];
}

- (UILongPressGestureRecognizer *)commentLongPress
{
    if (!_commentLongPress) {
        _commentLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressComment:)];
    }
    return _commentLongPress;
}

@end

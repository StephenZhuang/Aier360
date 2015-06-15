//
//  ZXCommentCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXDynamicComment.h"

@interface ZXCommentCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource,MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet UIImageView *commentIcon;
@property (nonatomic , weak) IBOutlet UIButton *headButton;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *emojiLabelHeight;
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *replyViewHeight;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic , weak) IBOutlet UIView *replyView;
@property (nonatomic , weak) IBOutlet UIImageView *replyBg;

@property (nonatomic , strong) ZXDynamicComment *dynamicComment;
@property (nonatomic , copy) void (^replyBlock)(ZXDynamicCommentReply *reply);
@property (nonatomic , copy) void (^userBlock)(long uid);
@end

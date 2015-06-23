//
//  ZXMessageCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/23.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXDynamicMessage.h"

@interface ZXMessageCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UIImageView *headImageView;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *contentLabel;
@property (nonatomic , weak) IBOutlet UILabel *dynamicContentLabel;
@property (nonatomic , weak) IBOutlet UIImageView *dynamicImageView;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;

+ (CGFloat)heightForContent:(NSString *)content;
- (void)confirgureUIWithDynamicMessage:(ZXDynamicMessage *)dynamicMessage;
@end

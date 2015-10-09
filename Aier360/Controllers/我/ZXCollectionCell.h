//
//  ZXCollectionCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXCollection.h"

@interface ZXCollectionCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UIImageView *headImg;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet UIImageView *contentImage;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *emojiLabelHeight;

- (void)configureUIWithCollection:(ZXCollection *)collection;
@end

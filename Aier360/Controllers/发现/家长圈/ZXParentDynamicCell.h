//
//  ZXParentDynamicCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/15.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXParentRepostVIew.h"
#import "ZXPersonalDynamic.h"

@interface ZXParentDynamicCell : UITableViewCell<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet UIImageView *headImageView;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , weak) IBOutlet ZXParentRepostVIew *repostView;

@property (nonatomic , weak) IBOutlet UIButton *sexButton;
@property (nonatomic , weak) IBOutlet UIImageView *jobImageView;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet UIButton *favButton;
@property (nonatomic , weak) IBOutlet UIButton *commentButton;
@property (nonatomic , weak) IBOutlet UIButton *actionButton;

@property (nonatomic , weak) IBOutlet NSLayoutConstraint *emojiLabelHeight;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *collecionViewHeight;

@property (nonatomic , strong) NSArray *imageArray;
@property (nonatomic , copy) void (^imageClickBlock)(NSInteger index);

- (void)configureWithDynamic:(ZXPersonalDynamic *)dynamic;
@end

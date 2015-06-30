//
//  ZXSchoolDynamicCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXPersonalDynamic.h"

@interface ZXSchoolDynamicCell : UITableViewCell<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet UIImageView *headImageView;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet UIButton *favButton;
@property (nonatomic , weak) IBOutlet UIButton *commentButton;

@property (nonatomic , weak) IBOutlet NSLayoutConstraint *emojiLabelHeight;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *collecionViewHeight;

@property (nonatomic , strong) NSArray *imageArray;
@property (nonatomic , copy) void (^imageClickBlock)(NSInteger index);
@property (nonatomic , copy) void (^headClickBlock)();

- (void)configureWithDynamic:(ZXPersonalDynamic *)dynamic;
@end

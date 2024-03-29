//
//  ZXDynamicDetailView.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXRepostView.h"
#import "ZXPersonalDynamic.h"

@interface ZXDynamicDetailView : UITableViewCell<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet UIImageView *headImageView;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , weak) IBOutlet ZXRepostView *repostView;

@property (nonatomic , weak) IBOutlet UIButton *sexButton;
@property (nonatomic , weak) IBOutlet UIImageView *jobImageView;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet UIButton *addressButton;
@property (nonatomic , weak) IBOutlet UIButton *deleteButton;
@property (nonatomic , weak) IBOutlet UIImageView *whocanseeImage;

@property (nonatomic , weak) IBOutlet NSLayoutConstraint *emojiLabelHeight;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *collecionViewHeight;

@property (nonatomic , strong) NSArray *imageArray;
@property (nonatomic , copy) void (^imageClickBlock)(NSInteger index);
@property (nonatomic , copy) void (^headClickBlock)();
@property (nonatomic , copy) void (^repostClickBlock)();
@property (nonatomic , copy) void (^squareLabelBlock)(NSInteger oslid);

- (void)configureWithDynamic:(ZXPersonalDynamic *)dynamic;
@end

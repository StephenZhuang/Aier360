//
//  ZXRepostView.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXPersonalDynamic.h"

@interface ZXRepostView : UIView<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *emojiLabelHeight;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *repostViewHeight;

@property (nonatomic , strong) NSArray *imageArray;
@property (nonatomic , copy) void (^imageClickBlock)(NSInteger index);

- (void)configureWithDynamic:(ZXPersonalDynamic *)dynamic;
@end

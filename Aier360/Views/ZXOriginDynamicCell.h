//
//  ZXOriginDynamicCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/11.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXDynamic.h"

@interface ZXOriginDynamicCell : ZXBaseCell<MLEmojiLabelDelegate, UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic , weak) IBOutlet MLEmojiLabel *emojiLabel;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSArray *imageArray;
@property (nonatomic , copy) void (^imageClickBlock)(NSInteger index);
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *collectionViewHeight;
+ (CGFloat)heightByDynamic:(ZXDynamic *)dynamic;
- (void)configureUIWithDynamic:(ZXDynamic *)dynamic;
@end

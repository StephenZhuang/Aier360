//
//  ZXImageCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"
#import "MagicalMacro.h"

@interface ZXImageCell : ZXBaseCell<UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSArray *imageArray;
@property (nonatomic , copy) void (^imageClickBlock)(NSInteger index);
+ (CGFloat)heightByImageArray:(NSArray *)imageArray;
@end

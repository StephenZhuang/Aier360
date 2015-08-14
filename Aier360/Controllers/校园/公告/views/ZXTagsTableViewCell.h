//
//  ZXTagsTableViewCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/13.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ERJustifiedFlowLayout/ERJustifiedFlowLayout.h>
#import "ERCollectionViewCell.h"

@interface ZXTagsTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) NSMutableArray *selectedArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ERCollectionViewCell *sizingCell;
@property (weak, nonatomic) IBOutlet ERJustifiedFlowLayout *customJustifiedFlowLayout;

@property (nonatomic , copy) void (^clickBlock)(NSInteger index);
- (CGFloat)getHeight;
@end

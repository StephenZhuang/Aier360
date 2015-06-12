//
//  ZXFavourCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXFavourCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UIButton *favourButton;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *collectionViewWidth;
@property (nonatomic , strong) NSArray *userArray;

- (void)configureCellWithUsers:(NSArray *)userArray total:(NSInteger)total;
@end

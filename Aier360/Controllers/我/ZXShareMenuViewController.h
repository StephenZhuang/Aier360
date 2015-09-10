//
//  ZXShareMenuViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXShareMenuViewController : ZXBaseViewController<UICollectionViewDelegate ,UICollectionViewDataSource>
@property (nonatomic , weak) IBOutlet UIView *menuView;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic , copy) void (^shareBlock)(NSInteger index);
@property (nonatomic , weak) IBOutlet UIView *maskView;
@end

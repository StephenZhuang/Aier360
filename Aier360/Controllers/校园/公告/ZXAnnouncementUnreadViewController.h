//
//  ZXAnnouncementUnreadViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//
#import "ZXBaseViewController.h"

@interface ZXAnnouncementUnreadViewController : ZXBaseViewController<UICollectionViewDelegate ,UICollectionViewDataSource>
@property (nonatomic , strong) NSArray *teacherArray;
@property (nonatomic , strong) NSArray *parentArray;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , assign) long mid;
@property (nonatomic , assign) NSInteger type;
@end

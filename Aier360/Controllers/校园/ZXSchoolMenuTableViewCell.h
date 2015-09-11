//
//  ZXSchoolMenuTableViewCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/6.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXSchoolMenuTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>         
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , copy) void (^selectIndexBlock)(NSInteger index);

- (void)configureWithDataArray:(NSMutableArray *)dataArray;
@end

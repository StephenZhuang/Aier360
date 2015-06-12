//
//  ZXRefreshCollectionViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "MJRefresh.h"

@interface ZXRefreshCollectionViewController : ZXBaseViewController
{
@protected
    NSInteger page;
    NSInteger pageCount;
    BOOL hasMore;
}
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *dataArray;

- (void)loadData;
- (void)addHeader;
- (void)addFooter;
- (void)configureArray:(NSArray *)array;
@end

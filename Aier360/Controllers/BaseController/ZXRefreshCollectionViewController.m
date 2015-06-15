//
//  ZXRefreshCollectionViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshCollectionViewController.h"

@implementation ZXRefreshCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
    pageCount = 10;
    hasMore = YES;
    self.dataArray = [[NSMutableArray alloc] init];
    [self addHeader];
    [self addFooter];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)addFooter
{
    [self.collectionView addFooterWithCallback:^(void){
        page ++;
        [self loadData];
    }];
}

- (void)addHeader
{
    [self.collectionView addHeaderWithCallback:^(void) {
        if (!hasMore) {
            [self.collectionView setFooterHidden:NO];
        }
        page = 1;
        hasMore = YES;
        [self loadData];
    }];
    [self.collectionView headerBeginRefreshing];
}

- (void)loadData
{
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    
    for (int i = 0; i < pageCount; i++) {
        int random = arc4random_uniform(1000000);
        [self.dataArray addObject:[NSString stringWithFormat:@"随机数据---%d", random]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.collectionView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        if (page == 1) {
            [self.collectionView headerEndRefreshing];
        } else {
            [self.collectionView footerEndRefreshing];
            if (page == 5) {
                hasMore = NO;
                if (!hasMore) {
                    [self.collectionView setFooterHidden:YES];
                }
            }
        }
    });
}

- (void)configureArray:(NSArray *)array
{
    if (page == 1) {
        [self.dataArray removeAllObjects];
    }
    if (array) {
        [self.dataArray addObjectsFromArray:array];
        if (array.count < pageCount) {
            hasMore = NO;
            [self.collectionView setFooterHidden:YES];
        }
    } else {
        hasMore = NO;
        [self.collectionView setFooterHidden:YES];
    }
    [self.collectionView reloadData];
    if (page == 1) {
        [self.collectionView headerEndRefreshing];
    } else {
        [self.collectionView footerEndRefreshing];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    MTopic *topic = [_topicArray objectAtIndex:indexPath.row];
    //    TopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopicCell" forIndexPath:indexPath];
    //    [cell.nameLabel setText:topic.name];
    //    [cell.topicImage setImageWithURL:[ToolUtils getImageUrlWtihString:topic.img] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    //    cell.layer.borderWidth = 1;
    //    cell.layer.borderColor = RGB(51, 51, 51).CGColor;
    //    return cell;
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *view = nil;
//    if ([kind isEqual:UICollectionElementKindSectionFooter]) {
//        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionFooter" forIndexPath:indexPath];
////        if (view == nil) {
////            view = [[UICollectionReusableView alloc] initWithFrame:_footer.frame];
////            [_footer setFrame:_footer.bounds];
////            [view addSubview:_footer];
////        }
//        for (UIView *subview in view.subviews) {
//            [subview removeFromSuperview];
//        }
//        [_footer setFrame:_footer.bounds];
//        [view addSubview:_footer];
//
//    }
//    return view;
//}
@end

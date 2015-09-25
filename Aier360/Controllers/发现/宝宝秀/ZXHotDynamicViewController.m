//
//  ZXHotDynamicViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHotDynamicViewController.h"
#import "ZXPersonalDynamic+ZXclient.h"
#import "MagicalMacro.h"
#import "ZXHotDynamicCell.h"
#import "ZXPersonalDyanmicDetailViewController.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXHotDynamicViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXHotDynamicViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat itemWidth = (SCREEN_WIDTH - 15) / 2.0;
    CGFloat itemHeight = itemWidth * 33 / 36.0 + 45;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(7, 5, 5, 5);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 7;
    layout.minimumInteritemSpacing = 5;
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}

- (void)loadData
{
    [ZXPersonalDynamic getHotDynamicWithUid:GLOBAL_UID page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

#pragma mark - collectionview delegate
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
    ZXHotDynamicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXHotDynamicCell" forIndexPath:indexPath];
    ZXPersonalDynamic *dynamic = self.dataArray[indexPath.row];
    [cell configureCellWithDynamic:dynamic];
    cell.favButton.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:indexPath.row];
    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
    vc.did = dynamc.did;
    vc.isCachedDynamic = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)favAction:(UIButton *)sender
{
    if (sender.selected) {
        [MBProgressHUD showText:@"您已经喜欢过了~" toView:self.view];
    } else {
        ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:sender.tag];
        dynamc.hasParise = 1;
        dynamc.pcount++;
        sender.selected = YES;
        [ZXPersonalDynamic praiseDynamicWithUid:GLOBAL_UID did:dynamc.did type:3 block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                dynamc.hasParise = 0;
                dynamc.pcount = MAX(0, dynamc.pcount-1);
                sender.selected = NO;
                [MBProgressHUD showText:errorInfo toView:self.view];
            }
        }];
    }
}
@end

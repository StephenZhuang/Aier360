//
//  ZXFavourListViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFavourListViewController.h"
#import "ZXUser+ZXclient.h"
#import "ZXBaseCollectionViewCell.h"
#import "ZXUserProfileViewController.h"
#import "ZXMyProfileViewController.h"

@implementation ZXFavourListViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXFavourListViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"喜欢";
}

- (void)addFooter{}

- (void)loadData
{
    [ZXUser getPrasedUserWithDid:_did limitNumber:0 block:^(NSArray *array, NSInteger total, NSError *error) {
        [self configureArray:array];
    }];
}

#pragma mark - collectionView delegate
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
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ZXUser *user = [self.dataArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.titleLabel setText:user.nickname];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXUser *user = [self.dataArray objectAtIndex:indexPath.row];
    if (user.uid == GLOBAL_UID) {
        ZXMyProfileViewController *vc = [ZXMyProfileViewController viewControllerFromStoryboard];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ZXUserProfileViewController *vc = [ZXUserProfileViewController viewControllerFromStoryboard];
        vc.uid = user.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

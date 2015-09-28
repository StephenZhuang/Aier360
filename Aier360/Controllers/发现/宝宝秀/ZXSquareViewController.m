//
//  ZXSquareViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSquareViewController.h"
#import "MagicalMacro.h"
#import "ZXSquareLabel+ZXclient.h"
#import "ZXBaseCollectionViewCell.h"
#import "ZXSquareDynamicsViewController.h"

@implementation ZXSquareViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSquareViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)loadData
{
    [ZXSquareLabel getSquareLabelListWithBlock:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (void)addFooter{}

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
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ZXSquareLabel *squareLabel = self.dataArray[indexPath.row];
    [cell.titleLabel setText:squareLabel.name];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[ZXImageUrlHelper imageUrlForSquareLabel:squareLabel.img].absoluteString stringByReplacingOccurrencesOfString:@"small" withString:@"big"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    cell.imageView.layer.masksToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXSquareLabel *squareLabel = [self.dataArray objectAtIndex:indexPath.row];
    ZXSquareDynamicsViewController *vc = [ZXSquareDynamicsViewController viewControllerFromStoryboard];
    vc.oslid = squareLabel.id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

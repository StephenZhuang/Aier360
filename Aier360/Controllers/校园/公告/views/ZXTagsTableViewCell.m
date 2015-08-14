//
//  ZXTagsTableViewCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/13.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXTagsTableViewCell.h"
#import "ZXTeacherNew.h"
#import "MagicalMacro.h"

@implementation ZXTagsTableViewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    UINib *cellNib = [UINib nibWithNibName:@"ERCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ERCollectionViewCell"];
    
    self.sizingCell = [[cellNib instantiateWithOwner:nil options:nil] firstObject];
    
    self.customJustifiedFlowLayout.horizontalJustification = FlowLayoutHorizontalJustificationLeft;
    self.customJustifiedFlowLayout.horizontalCellPadding = 5;
    self.customJustifiedFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - collectionView delegate
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ERCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ERCollectionViewCell" forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    !_clickBlock?:_clickBlock(indexPath.row);
}

- (void)configureCell:(ERCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    cell.labelText = [self.selectedArray[indexPath.row] tname];
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:self.sizingCell forIndexPath:indexPath];
    
    return [self.sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

- (void)setSelectedArray:(NSMutableArray *)selectedArray
{
    _selectedArray = selectedArray;
    [self.collectionView reloadData];
}

- (CGFloat)getHeight
{
    CGFloat collectionViewWidth = SCREEN_WIDTH - 30;
    NSInteger line = 1;
    CGFloat x = 0;
    for (int i = 0; i < self.selectedArray.count; i++) {
        CGSize size = [self collectionView:self.collectionView layout:self.customJustifiedFlowLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if (x + size.width > collectionViewWidth) {
            line++;
            x = 0;
            x += size.width + 5;
        } else {
            x += size.width + 5;
        }
    }
    
    CGFloat height = line * 21 + (line -1) * 5;
    return height + 30;
}
@end

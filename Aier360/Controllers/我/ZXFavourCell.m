//
//  ZXFavourCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFavourCell.h"
#import "ZXBaseCollectionViewCell.h"
#import "ZXUser.h"

@implementation ZXFavourCell
- (void)configureCellWithUsers:(NSArray *)userArray total:(NSInteger)total
{
    [self setUserArray:userArray];
    if (total == 0) {
        [self.contentLabel setText:@"还没有人喜欢哦"];
    } else {
        if (total > userArray.count) {
            [self.contentLabel setText:[NSString stringWithFormat:@"等%@人喜欢",@(total)]];
        } else {
            [self.contentLabel setText:[NSString stringWithFormat:@"%@人喜欢",@(total)]];
        }
    }
}

#pragma mark - collentionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.userArray) {
        return self.userArray.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ZXUser *user = self.userArray[indexPath.row];
    NSString *imageUrl = user.headimg;
    [cell.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForType:ZXImageTypeHeadImg imageName:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXUser *user = self.userArray[indexPath.row];
    !_userClickBlick?:_userClickBlick(user.uid);
}

- (void)setUserArray:(NSArray *)userArray
{
    _userArray = userArray;
    [self.collectionView reloadData];
    
    CGFloat itemWidth = 25;
    CGFloat height = userArray.count * itemWidth + (userArray.count) * 5;
    self.collectionViewWidth.constant = MAX(0, height);
    [self setNeedsLayout];
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
}
@end

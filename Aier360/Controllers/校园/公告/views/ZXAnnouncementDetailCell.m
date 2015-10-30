//
//  ZXAnnouncementDetailCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementDetailCell.h"
#import "MagicalMacro.h"
#import "ZXBaseCollectionViewCell.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>

@implementation ZXAnnouncementDetailCell
- (void)configureWithAnnouncement:(ZXAnnouncement *)announcement
{
    [self.titleLabel setText:announcement.title];
    [self.timeLabel setText:announcement.ctime_str];
    [self.contentLabel setText:announcement.message];
    if (announcement.img.length > 0) {
        self.collectionView.fd_collapsed = NO;
        NSArray *arr = [announcement.img componentsSeparatedByString:@","];
        self.imageArray = arr;
    } else {
        self.collectionView.fd_collapsed = YES;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    CGFloat itemWidth = (SCREEN_WIDTH - 45) / 3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 7;
    layout.minimumInteritemSpacing = 7;
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}

#pragma mark - collentionview delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArray) {
        return self.imageArray.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *imageUrl = self.imageArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSmall:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_imageClickBlock) {
        _imageClickBlock(indexPath.row);
    }
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [self.collectionView reloadData];
    
    CGFloat itemWidth = (SCREEN_WIDTH - 45) / 3;
    int line = 0;
    line = (int)ceilf(imageArray.count / 3.0);
    CGFloat height = line * itemWidth + (line - 1) * 7;
    self.collecionViewHeight.constant = height;
}
@end

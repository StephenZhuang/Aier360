//
//  ZXEmojiPicker.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/9.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXEmojiPicker.h"
#import "ZXBaseCollectionViewCell.h"
#import "MagicalMacro.h"

@implementation ZXEmojiPicker

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"];
        _dataArray = [[NSArray alloc] initWithContentsOfFile:path];
        _showing = NO;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    CGFloat itemWidth = (SCREEN_WIDTH - 40) / 7;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    [_collectionView setCollectionViewLayout:layout animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:_dataArray[indexPath.row]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_emojiBlock) {
        _emojiBlock([NSString stringWithFormat:@"[%@]",_dataArray[indexPath.row]]);
    }
}

- (void)show
{
    _showing = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, 0, -CGRectGetHeight(self.frame));
    }];
}

- (void)hide
{
    _showing = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

@end

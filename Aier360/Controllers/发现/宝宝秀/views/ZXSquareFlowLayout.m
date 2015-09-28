//
//  ZXSquareFlowLayout.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSquareFlowLayout.h"
#import "MagicalMacro.h"

@implementation ZXSquareFlowLayout
- (id)init
{
    if (!(self = [super init])) return nil;
    
    self.sectionInset = UIEdgeInsetsMake(7, 5, 7, 5);
    self.minimumLineSpacing = 7;
    self.minimumInteritemSpacing = 5;
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(7, 5, 7, 5);
        self.minimumLineSpacing = 7;
        self.minimumInteritemSpacing = 5;
    }
    return self;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray * modifiedLayoutAttributesArray = [NSMutableArray array];
    
    NSInteger dataCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < dataCount; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [modifiedLayoutAttributesArray addObject:attributes];
    }
    return modifiedLayoutAttributesArray;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat itemWidth = (SCREEN_WIDTH - 15) / 2.0;
    CGFloat itemHeight = (itemWidth - 7) / 2.0;
    if (indexPath.row == 0) {
        layoutAttributes.frame = CGRectMake(5, 7, itemWidth, itemWidth);
    } else if (indexPath.row == 1) {
        layoutAttributes.frame = CGRectMake(10+itemWidth, 7, itemWidth, itemHeight);
    } else if (indexPath.row == 2) {
        layoutAttributes.frame = CGRectMake(10+itemWidth, 14+itemHeight, itemWidth, itemHeight);
    } else {
        layoutAttributes.frame = CGRectMake(5+((indexPath.row-3)%2)*(itemWidth+5), 14 + itemWidth +((indexPath.row-3)/2)*(itemHeight+7), itemWidth, itemHeight);
    }
    return layoutAttributes;
}

- (CGSize)collectionViewContentSize
{
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:count-1 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    return CGSizeMake(SCREEN_WIDTH, attributes.frame.origin.y + attributes.frame.size.height + 7);
}
@end

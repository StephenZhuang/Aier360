//
//  ZXSchoolMenuTableViewCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/6.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolMenuTableViewCell.h"
#import "MagicalMacro.h"
#import "ZXSchoolMenuCollectionViewCell.h"

@implementation ZXSchoolMenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    CGFloat itemWidth = SCREEN_WIDTH / 4;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, 100);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithDataArray:(NSMutableArray *)dataArray unreadNum:(NSInteger)unreadNum
{
    self.unreadNum = unreadNum;
    self.dataArray = dataArray;
    [self.collectionView reloadData];
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
    ZXSchoolMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXSchoolMenuCollectionViewCell" forIndexPath:indexPath];
    if ((indexPath.row + 1) % 4 == 0) {
        cell.virticalLine.hidden = YES;
    } else {
        cell.virticalLine.hidden = NO;
    }
    
    NSString *string = self.dataArray[indexPath.row];
    NSString *imageName = string;
    if ([imageName isEqualToString:@"教工列表"]) {
        imageName = @"班级列表";
    }
    [cell.iconImage setImage:[UIImage imageNamed:imageName]];
    [cell.nameLabel setText:string];
    if ([string isEqualToString:@"校园动态"] && self.unreadNum > 0) {
        [cell.badgeView setHidden:NO];
    } else {
        [cell.badgeView setHidden:YES];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    !_selectIndexBlock?:_selectIndexBlock(indexPath.row);
}

#pragma mark - getters and setters
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end

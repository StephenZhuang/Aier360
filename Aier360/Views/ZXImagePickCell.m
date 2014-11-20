//
//  ZXImagePickCell.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXImagePickCell.h"
#import "ZXBaseCollectionViewCell.h"

@implementation ZXImagePickCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat itemWidth = (SCREEN_WIDTH - 40) / 4;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    [_collectionView setCollectionViewLayout:layout animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imageArray) {
        return MIN(Image_Count_Max, _imageArray.count+1);
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *imageUrl = _imageArray[indexPath.row];
    if (indexPath.row == _imageArray.count) {
        
    } else {
        [cell.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForFresh:imageUrl]];
    }
    cell.imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [_collectionView reloadData];
}

+ (CGFloat)heightByImageArray:(NSArray *)imageArray
{
    CGFloat itemWidth = (SCREEN_WIDTH - 40) / 4;
    int line = 0;
    line = (int)ceilf((imageArray.count + 1) / 4.0);
    return line * itemWidth + (line + 1) * 8;
}

@end

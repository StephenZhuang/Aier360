//
//  ZXSchoolMenuHeader.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/7.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolMenuHeader.h"
#import "ZXSchoolMenuCollectionViewCell.h"
#import "MagicalMacro.h"
#import "ZXCropSchoolImageViewController.h"
#import <UIView+FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>

@implementation ZXSchoolMenuHeader
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.schoolImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.schoolImageView.layer.masksToBounds = YES;
    
    CGFloat itemWidth = SCREEN_WIDTH / 4.0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, 50);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [self.collectionView setCollectionViewLayout:layout animated:YES];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZXSchoolMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZXSchoolMenuCollectionViewCell"];
}

- (void)configureUIWithSchool:(ZXSchool *)school
{
    [self.schoolImageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForOrigin:school.img] placeholderImage:[UIImage imageNamed:@"schoolimage_default_small"]];
    self.imageHeight.constant = SCREEN_WIDTH * Small_Proportion;
    
    [self.schoolNameLabel setText:school.name];
    [self.imgNumButton setTitle:[NSString stringWithFormat:@"%@",@(school.num_img)] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSchoolImg)];
    [self.schoolImageView addGestureRecognizer:tap];
    self.schoolImageView.userInteractionEnabled = YES;
    
    NSInteger line = (NSInteger)ceilf(self.dataArray.count / 4.0);
    self.collectionViewHeight.constant = line * 50;
    
    if (HASIdentyty(ZXIdentitySchoolMaster) || HASIdentyty(ZXIdentityClassMaster) || HASIdentyty(ZXIdentityTeacher)) {
        self.addClassDynamicButton.fd_collapsed = NO;
    } else {
        self.addClassDynamicButton.fd_collapsed = YES;
    }
    
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        self.filterButton.hidden = NO;
    } else {
        self.filterButton.hidden = YES;
    }
}

- (void)gotoSchoolImg
{
    !_schollImageBlock?:_schollImageBlock();
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
    
//    if (indexPath.row == 0 && hasNewDynamic) {
//        cell.badgeView.hidden = NO;
//    } else {
//        cell.badgeView.hidden = YES;
//    }
    
    NSString *string = self.dataArray[indexPath.row];
    if ([string isEqualToString:@"教工列表"]) {
        string = @"教师列表";
    }
    NSString *imageName = string;
    if ([imageName isEqualToString:@"教工列表"]) {
        imageName = @"教师列表";
    }
    
    if ([string isEqualToString:@"短信账户"]) {
        if (self.hasReward) {
            cell.messageAccountTip.hidden = NO;
        } else {
            cell.messageAccountTip.hidden = YES;
        }
    } else {
        cell.messageAccountTip.hidden = YES;
    }
    [cell.iconImage setImage:[UIImage imageNamed:imageName]];
    [cell.nameLabel setText:string];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    !_SelectedIndexBlock?:_SelectedIndexBlock(indexPath.row);
}

#pragma mark - setters and getters
- (void)setData:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end

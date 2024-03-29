//
//  ZXAnnouncementUnreadViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAnnouncementUnreadViewController.h"
#import "ZXAnnouncementUnreadSectionHeader.h"
#import "ZXBaseCollectionViewCell.h"
#import "UIViewController+ZXProfile.h"
#import "ZXAnnouncement+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"

@implementation ZXAnnouncementUnreadViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXAnnouncementUnreadViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"未阅列表";
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    [ZXAnnouncement getAnnoucementUnreadWithSid:[ZXUtils sharedInstance].currentSchool.sid
                                            mid:_mid type:_type block:^(ZXAnnouncement *announcement, NSError *error) {
        [hud hide:YES];
        self.teacherArray = announcement.unReadedTeachers;
        self.parentArray = announcement.unReadedParents;
        [self.collectionView reloadData];
    }];
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.teacherArray.count;
    } else {
        return self.parentArray.count;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        ZXAnnouncementUnreadSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ZXAnnouncementUnreadSectionHeader" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            [header.titleLabel setText:[NSString stringWithFormat:@"教师(%@)",@(self.teacherArray.count)]];
        } else {
            [header.titleLabel setText:[NSString stringWithFormat:@"家长(%@)",@(self.parentArray.count)]];
        }
        return header;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXBaseCollectionViewCell" forIndexPath:indexPath];
    ZXUser *user;
    if (indexPath.section == 0) {
        user = self.teacherArray[indexPath.row];
    } else {
        user = self.parentArray[indexPath.row];
    }
    [cell.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForHeadImg:user.headimg] placeholderImage:[UIImage imageNamed:@"head_default"]];
    [cell.titleLabel setText:user.nickname];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXUser *user;
    if (indexPath.section == 0) {
        user = self.teacherArray[indexPath.row];
    } else {
        user = self.parentArray[indexPath.row];
    }
    [self gotoProfileWithUid:user.uid];
}

#pragma mark - setters and getters
- (NSArray *)teacherArray
{
    if (!_teacherArray) {
        _teacherArray = [[NSArray alloc] init];
    }
    return _teacherArray;
}

- (NSArray *)parentArray
{
    if (!_parentArray) {
        _parentArray = [[NSArray alloc] init];
    }
    return _parentArray;
}
@end

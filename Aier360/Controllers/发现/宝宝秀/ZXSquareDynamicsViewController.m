//
//  ZXSquareDynamicsViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSquareDynamicsViewController.h"
#import "MagicalMacro.h"
#import "ZXHotDynamicCell.h"
#import "ZXPersonalDynamic+ZXclient.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXPersonalDyanmicDetailViewController.h"
#import "ZXSqualeDetailView.h"
#import "ZXReleaseMyDynamicViewController.h"

@implementation ZXSquareDynamicsViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSquareDynamicsViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureSquareLabel];
}

- (IBAction)addAction:(id)sender
{
    ZXReleaseMyDynamicViewController *vc = [ZXReleaseMyDynamicViewController viewControllerFromStoryboard];
    [vc.squareLabelArray addObject:self.squareLabel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)loadData
{
    if (page == 1) {
        if (self.squareLabel) {
//            [self configureSquareLabel];
            
        } else {
            [ZXSquareLabel getSquareLabelWithOslid:self.oslid block:^(ZXSquareLabel *squareLabel, NSError *error) {
                self.squareLabel = squareLabel;
                [self configureSquareLabel];
            }];
        }
    }
    
    [ZXPersonalDynamic getSquareDynamicWithUid:GLOBAL_UID oslid:self.oslid page:page pageSize:pageCount block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (void)configureSquareLabel
{
    self.title = self.squareLabel.name;
    NSString *string = self.squareLabel.desc;
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = CGSizeMake(SCREEN_WIDTH - 30,2000);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelsize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGFloat itemWidth = (SCREEN_WIDTH - 15) / 2.0;
    CGFloat itemHeight = itemWidth * 33 / 36.0 + 45;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(7, 5, 5, 5);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 7;
    layout.minimumInteritemSpacing = 5;
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 109+25+labelsize.height);
    [self.collectionView setCollectionViewLayout:layout animated:NO];
    [self.collectionView reloadData];
}

#pragma mark - collectionview delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZXSqualeDetailView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ZXSqualeDetailView" forIndexPath:indexPath];
        [header.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSquareLabel:self.squareLabel.img type:ZXImageTypeOrigin] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [header.contentLabel setText:self.squareLabel.desc];
        return header;
    } else {
        return nil;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXHotDynamicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZXHotDynamicCell" forIndexPath:indexPath];
    ZXPersonalDynamic *dynamic = self.dataArray[indexPath.row];
    [cell configureCellWithDynamic:dynamic];
    cell.favButton.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:indexPath.row];
    ZXPersonalDyanmicDetailViewController *vc = [ZXPersonalDyanmicDetailViewController viewControllerFromStoryboard];
    vc.did = dynamc.did;
    vc.isCachedDynamic = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)favAction:(UIButton *)sender
{
    if (sender.selected) {
        [MBProgressHUD showText:@"您已经喜欢过了~" toView:self.view];
    } else {
        ZXPersonalDynamic *dynamc = [self.dataArray objectAtIndex:sender.tag];
        dynamc.hasParise = 1;
        dynamc.pcount++;
        sender.selected = YES;
        [sender setTitle:[NSString stringWithFormat:@"%@",@(dynamc.pcount)] forState:UIControlStateNormal];
        [sender setTitle:[NSString stringWithFormat:@"%@",@(dynamc.pcount)] forState:UIControlStateSelected];
        [ZXPersonalDynamic praiseDynamicWithUid:GLOBAL_UID did:dynamc.did type:3 block:^(BOOL success, NSString *errorInfo) {
            if (!success) {
                dynamc.hasParise = 0;
                dynamc.pcount = MAX(0, dynamc.pcount-1);
                sender.selected = NO;
                [sender setTitle:[NSString stringWithFormat:@"%@",@(dynamc.pcount)] forState:UIControlStateNormal];
                [sender setTitle:[NSString stringWithFormat:@"%@",@(dynamc.pcount)] forState:UIControlStateSelected];
                [MBProgressHUD showText:errorInfo toView:self.view];
            }
        }];
    }
}
@end

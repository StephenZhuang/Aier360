//
//  ZXShareMenuViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXShareMenuViewController.h"
#import "ZXShareMenuCollectionViewCell.h"
#import "MagicalMacro.h"

#define MENU_HEIGHT 236

@interface ZXShareMenuViewController ()
@property (nonatomic , strong) NSArray *nameArray;
@property (nonatomic , strong) NSArray *imageArray;
@end

@implementation ZXShareMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self showMenu];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu:)];
    [self.maskView addGestureRecognizer:tap];
    self.maskView.userInteractionEnabled = YES;
    
    CGFloat itemWidth = SCREEN_WIDTH / 3.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(25, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, 68);
    layout.minimumLineSpacing = 25;
    layout.minimumInteritemSpacing = 0;
    [_collectionView setCollectionViewLayout:layout animated:YES];
}

- (void)showMenu
{
    [UIView animateWithDuration:0.25 animations:^{
        self.menuView.transform = CGAffineTransformMakeTranslation(0, -MENU_HEIGHT);
    }];
}

- (IBAction)hideMenu:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.menuView.transform = CGAffineTransformMakeTranslation(0, MENU_HEIGHT);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZXShareMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dynamic_ic_%@_n",self.imageArray[indexPath.row]]]];
    [cell.iconImage setHighlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"dynamic_ic_%@_h",self.imageArray[indexPath.row]]]];
    [cell.titleLabel setText:self.nameArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    !_shareBlock?:_shareBlock(indexPath.row);
    [self hideMenu:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters and setters
- (NSArray *)nameArray
{
    return @[@"微信好友",@"微信朋友圈",@"爱儿邦好友圈"];
}

- (NSArray *)imageArray
{
    return @[@"weixin",@"timeline",@"parentCircle"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

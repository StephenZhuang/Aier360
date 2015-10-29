//
//  ZXSchoolImageViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSchoolImageViewController.h"
#import "ZXSchoolImg+ZXclient.h"
#import "ZXBaseCollectionViewCell.h"
#import "MagicalMacro.h"
#import "ZXReleaseSchoolImageViewController.h"
#import "ZXPopMenu.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXNotificationHelper.h"

@implementation ZXSchoolImageViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXSchoolImageViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"校园图片";
    
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    CGFloat itemWidth = (SCREEN_WIDTH - 12) / 3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumLineSpacing = 6;
    layout.minimumInteritemSpacing = 6;
    [self.collectionView setCollectionViewLayout:layout animated:YES];
}

- (void)submit
{
    ZXReleaseSchoolImageViewController *vc = [ZXReleaseSchoolImageViewController viewControllerFromStoryboard];
    vc.addSuccess = ^(void) {
        [self.collectionView headerBeginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    self.browser = nil;
}

- (void)loadData
{
    [ZXSchoolImg getSchoolImgListWithSid:[ZXUtils sharedInstance].currentSchool.sid block:^(NSArray *array, NSError *error) {
        [self configureArray:array];
    }];
}

- (void)addFooter{}

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
    ZXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ZXSchoolImg *img = [self.dataArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[ZXImageUrlHelper imageUrlForSmall:img.img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    cell.imageView.layer.masksToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self browseImage:self.dataArray index:indexPath.row];
}

- (void)browseImage:(NSArray *)imageArray index:(NSInteger)index
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (ZXSchoolImg *img in imageArray) {
        NSURL *url = [ZXImageUrlHelper imageUrlForType:ZXImageTypeOrigin imageName:img.img];
        MWPhoto *photo = [MWPhoto photoWithURL:url];
        photo.caption = img.info;
        [photos addObject:photo];
    }
    self.photos = photos;
    
    [self.browser setCurrentPhotoIndex:index];
    
    if (HASIdentyty(ZXIdentitySchoolMaster)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dynamic_bt_more"] style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
        self.browser.navigationItem.rightBarButtonItem = item;
    }
    [self.navigationController pushViewController:self.browser animated:YES];
}

- (void)popAction
{
    NSArray *contents = @[@"设为封面",@"删除"];
    __weak __typeof(&*self)weakSelf = self;
    ZXPopMenu *menu = [[ZXPopMenu alloc] initWithContents:contents targetFrame:CGRectMake(0, 0, self.view.frame.size.width - 15, 64)];
    menu.ZXPopPickerBlock = ^(NSInteger index) {
        if (index == 0) {
            [weakSelf setCover:[[self.dataArray objectAtIndex:self.browser.currentIndex] img]];
        } else {
            [weakSelf deleteImg:[[self.dataArray objectAtIndex:self.browser.currentIndex] img]];
        }
    };
    [self.browser.navigationController.view addSubview:menu];
}

- (void)deleteImg:(NSString *)img
{
    [ZXSchoolImg deleteSchoolImageWithSid:[ZXUtils sharedInstance].currentSchool.sid simg:img block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [MBProgressHUD showSuccess:@"" toView:nil];
        }
    }];
}

- (void)setCover:(NSString *)img
{
    [ZXSchoolImg setCoverWithSid:[ZXUtils sharedInstance].currentSchool.sid simg:img block:^(BOOL success, NSString *errorInfo) {
        if (success) {
            [MBProgressHUD showSuccess:@"" toView:nil];
            [ZXUtils sharedInstance].currentSchool.img = img;
            [[NSNotificationCenter defaultCenter] postNotificationName:changeSchoolNotification object:nil];
        }
    }];
}



#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = [self.photos objectAtIndex:index];
    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
    return captionView;
}

#pragma mark - setters and getters
- (MWPhotoBrowser *)browser
{
    if (!_browser) {
        BOOL displayActionButton = YES;
        BOOL displaySelectionButtons = NO;
        BOOL displayNavArrows = NO;
        BOOL enableGrid = NO;
        BOOL startOnGrid = NO;
        _browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _browser.displayActionButton = displayActionButton;
        _browser.displayNavArrows = displayNavArrows;
        _browser.displaySelectionButtons = displaySelectionButtons;
        _browser.alwaysShowControls = displaySelectionButtons;
        _browser.zoomPhotosToFill = YES;
        _browser.enableGrid = enableGrid;
        _browser.startOnGrid = startOnGrid;
        _browser.enableSwipeToDismiss = YES;
    }
    return _browser;
}
@end

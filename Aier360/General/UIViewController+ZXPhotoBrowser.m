//
//  UIViewController+ZXPhotoBrowser.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/22.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "UIViewController+ZXPhotoBrowser.h"

@implementation UIViewController (ZXPhotoBrowser)
@dynamic photos;

static char photoKey;

- (void)browseImage:(NSArray *)imageArray type:(ZXImageType)type index:(NSInteger)index
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSString *imageName in imageArray) {
        NSURL *url = [ZXImageUrlHelper imageUrlForType:type imageName:imageName];
        url = [NSURL URLWithString:[url.absoluteString stringByReplacingOccurrencesOfString:@"small" withString:@"origin"]];
        [photos addObject:[MWPhoto photoWithURL:url]];
    }
    self.photos = photos;

    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
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


- (void)setPhotos:(NSMutableArray *)photos
{
    objc_setAssociatedObject(self, &photoKey, photos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)photos
{
    return objc_getAssociatedObject(self, &photoKey);
}

@end

//
//  ZXFoodImagePickerViewController.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/27.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXFoodImagePickerViewController.h"
#import "ZXImagePickCell.h"
#import <PureLayout/PureLayout.h>

@interface ZXFoodImagePickerViewController ()
{
    NSMutableArray *_selections;
}
@property (nonatomic , weak) IBOutlet UIView *maskView;
@property (nonatomic , weak) IBOutlet UIView *pickView;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *heightConstraint;
@end

@implementation ZXFoodImagePickerViewController

+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Announcement" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXFoodImagePickerViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
    [self.view updateConstraintsIfNeeded];
    self.imageArray = [[NSMutableArray alloc] init];
    [self.pickView setHidden:YES];
    self.pickView.transform = CGAffineTransformTranslate(self.pickView.transform, 0, CGRectGetHeight(self.pickView.frame));
    [self loadAssets];
}

- (void)showOnViewControlelr:(UIViewController *)viewController
{
    [viewController addChildViewController:self];
    self.view.frame = viewController.view.bounds;
    [viewController.view addSubview:self.view];
    [self show];
}

- (void)show
{
    [self.pickView setHidden:NO];
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.pickView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^(void) {
        self.pickView.transform = CGAffineTransformTranslate(self.pickView.transform, 0, CGRectGetHeight(self.pickView.frame));
    } completion:^(BOOL isFinished) {
        [self.pickView setHidden:YES];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)cancelAction:(id)sender
{
    [self hide];
}

- (IBAction)doneAction:(id)sender
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    @synchronized(_assets) {
        NSMutableArray *copy = [_assets copy];
        for (int i = 0; i < _selections.count; i++) {
            NSNumber *number = _selections[i];
            if (number.boolValue) {
                ALAsset *asset = copy[i];
                [array addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
            }
        }
    }
    if (array.count > 0 && _pickBlock) {
        _pickBlock(array);
    }
    [self hide];
}

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    [self.tableView reloadData];
    
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)updateViewConstraints
{
    CGFloat height = 44 + [ZXImagePickCell heightByImageArray:_imageArray];
    _heightConstraint.constant = height;
    
    [super updateViewConstraints];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZXImagePickCell heightByImageArray:_imageArray];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(&*self)weakSelf = self;
    ZXImagePickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImagePickCell"];
    [cell setImageArray:_imageArray];
    cell.clickBlock = ^(NSIndexPath *indexPath) {
        [weakSelf.view endEditing:YES];
        [weakSelf showAssets];
        if (indexPath.row == _imageArray.count) {
        } else {

        }
    };
    return cell;
}

- (void)showAssets
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    @synchronized(_assets) {
        NSMutableArray *copy = [_assets copy];
        for (ALAsset *asset in copy) {
            [photos addObject:[MWPhoto photoWithURL:asset.defaultRepresentation.url]];
            [thumbs addObject:[MWPhoto photoWithImage:[UIImage imageWithCGImage:asset.thumbnail]]];
        }
    }
    self.photos = photos;
    self.thumbs = thumbs;
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = YES;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
    [self.parentViewController presentViewController:nav animated:YES completion:nil];
}

- (void)loadAssets {
    
    // Initialise
    _assets = [NSMutableArray new];
    _selections = [NSMutableArray new];
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    
    // Run in the background as it takes a while to get all assets from the library
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
        NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
        
        // Process assets
        void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result != nil) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                    NSURL *url = result.defaultRepresentation.url;
                    [_assetLibrary assetForURL:url
                                   resultBlock:^(ALAsset *asset) {
                                       if (asset) {
                                           @synchronized(_assets) {
                                               [_assets addObject:asset];
                                               [_selections addObject:[NSNumber numberWithBool:NO]];
                                               if (_assets.count == 1) {
                                                   // Added first asset so reload data
                                                   [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                               }
                                           }
                                       }
                                   }
                                  failureBlock:^(NSError *error){
                                      NSLog(@"operation was not successfull!");
                                  }];
                    
                }
            }
        };
        
        // Process groups
        void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil) {
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                [assetGroups addObject:group];
            }
        };
        
        // Process!
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                         usingBlock:assetGroupEnumerator
                                       failureBlock:^(NSError *error) {
                                           NSLog(@"There is an error");
                                       }];
        
    });
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    int i = 0;
    for (NSNumber *number in _selections) {
        if (number.boolValue) {
            i++;
        }
        if (i == 8) {
            break;
        }
    }
    if (i < 8) {
        [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
        NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
    }
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    @synchronized(_assets) {
        NSMutableArray *copy = [_assets copy];

        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < _selections.count; i++) {
            NSNumber *number = _selections[i];
            if (number.boolValue) {
                ALAsset *asset = copy[i];
                [array addObject:[UIImage imageWithCGImage:[asset thumbnail]]];
             }
         }
        self.imageArray = array;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

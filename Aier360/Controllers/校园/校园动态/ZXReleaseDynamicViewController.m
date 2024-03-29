//
//  ZXReleaseDynamicViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/20.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXReleaseDynamicViewController.h"
#import "ZXZipHelper.h"
#import "ZXUpDownLoadManager.h"
#import "ZXImagePickCell.h"
#import "ZXMenuCell.h"
#import "ZXPopPicker.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMapKit.h>
#import "ZXSelectSquareLabelViewController.h"
#import "ZXSelectLocationViewController.h"
#import "ZXEmojiPicker.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXReleaseDynamicViewController ()<BMKLocationServiceDelegate>
{
    NSMutableArray *_selections;
    BMKLocationService *locService;
}
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic , weak) IBOutlet ZXEmojiPicker *emojiPicker;
@property (nonatomic , weak) IBOutlet UILabel *letterNumLabel;

@end

@implementation ZXReleaseDynamicViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXReleaseDynamicViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布动态";
    [self loadAssets];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(releaseAction)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.letterNumLabel setText:[NSString stringWithFormat:@"%@",@([self maxLetter])]];
    [self.contentTextView setPlaceholder:@"有学校或班级的新动态？快和大家一起分享…"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (ZXSquareLabel *squareLabel in self.squareLabelArray) {
        [arr addObject:[NSString stringWithFormat:@"#%@#",squareLabel.name]];
    }
    NSString *labelString = [arr componentsJoinedByString:@""];
    self.contentTextView.text = [NSString stringWithFormat:@"%@%@",labelString,self.contentTextView.text];
    [self.tableView setExtrueLineHidden];
    self.emojiPicker.emojiBlock = ^(NSString *text) {
        [self.contentTextView insertText:text];
        [self textViewDidChange:self.contentTextView];
    };
    [self.tableView setSeparatorColor:[UIColor colorWithRed:237/255.0 green:235/255.0 blue:229/255.0 alpha:1.0]];
    
    self.address = @"";
    self.lat = 0;
    self.lng = 0;
    [self locationAction];
    [self configureAddressButton];
}

- (void)releaseAction
{
    !self.addSuccess?:self.addSuccess();
}

- (void)showActionSheet
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)showDeleteActionSheet:(NSInteger)index
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    actionSheet.tag = index;
    [actionSheet showInView:self.view];
}

- (IBAction)emojiAction:(UIButton *)sender
{
    [self.view bringSubviewToFront:self.emojiPicker];
    [sender setSelected:!sender.selected];
    if (sender.selected) {
        [self.view endEditing:YES];
        [self.emojiPicker show];
    } else {
        [self.emojiPicker hide];
    }
}

- (IBAction)squareLabelAction:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;
    ZXSelectSquareLabelViewController *vc = [ZXSelectSquareLabelViewController viewControllerFromStoryboard];
    NSMutableArray *oslidArray = [[NSMutableArray alloc] init];
    for (ZXSquareLabel *squareLabel in self.squareLabelArray) {
        [oslidArray addObject:[NSString stringWithFormat:@"%@",@(squareLabel.id)]];
    }
    NSString *oslids = [oslidArray componentsJoinedByString:@","];
    vc.oslids = oslids;
    vc.selectSquareLabelBlock = ^(NSMutableArray *array) {
        if (weakSelf.squareLabelArray.count > 0) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (ZXSquareLabel *squareLabel in weakSelf.squareLabelArray) {
                [arr addObject:[NSString stringWithFormat:@"#%@#",squareLabel.name]];
            }
            NSString *labelString = [arr componentsJoinedByString:@""];
            weakSelf.contentTextView.text = [weakSelf.contentTextView.text stringByReplacingOccurrencesOfString:labelString withString:@""];
        }
        weakSelf.squareLabelArray = array;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (ZXSquareLabel *squareLabel in weakSelf.squareLabelArray) {
            [arr addObject:[NSString stringWithFormat:@"#%@#",squareLabel.name]];
        }
        NSString *labelString = [arr componentsJoinedByString:@""];
        weakSelf.contentTextView.text = [NSString stringWithFormat:@"%@%@",labelString,weakSelf.contentTextView.text];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- address
- (void)configureAddressButton
{
    if (self.address.length > 0) {
        [self.addressButton setTitle:self.address forState:UIControlStateNormal];
        [self.addressDeleteButton setHidden:NO];
    } else {
        [self.addressButton setTitle:@"在哪?" forState:UIControlStateNormal];
        [self.addressDeleteButton setHidden:YES];
    }
    self.addressButtonView.layer.borderColor = [UIColor colorWithRed:232/255.0 green:229/255.0 blue:226/255.0 alpha:1.0].CGColor;
    self.addressButtonView.layer.borderWidth = 1;
}

- (IBAction)addressAction:(id)sender
{
    __weak __typeof(&*self)weakSelf = self;
    ZXSelectLocationViewController *vc = [ZXSelectLocationViewController viewControllerFromStoryboard];
    vc.lat = self.lat;
    vc.lng = self.lng;
    vc.addressBlock = ^(NSString *selectedAddress) {
        weakSelf.address = selectedAddress;
        [weakSelf configureAddressButton];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteAddressAction:(id)sender
{
    self.address = @"";
    [self configureAddressButton];
}

#pragma mark- textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (text.length == 0) {
        NSLog(@"====%@",@(range.location));
        NSLog(@"#");
        NSString *searchText = textView.text;
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#.+?#" options:NSRegularExpressionCaseInsensitive error:&error];

        NSArray *array = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
        if (array.count > 0) {
            for (NSTextCheckingResult *result in array) {
                if (range.location >= result.range.location && range.location < result.range.location + result.range.length) {
                    NSString *string = [searchText substringWithRange:result.range];
                    textView.text = [textView.text stringByReplacingOccurrencesOfString:string withString:@""];
                    NSString *name = [[string substringToIndex:string.length-1] substringFromIndex:1];
                    NSLog(@"%@      %@",string,name);
                    for (ZXSquareLabel *squareLabel in self.squareLabelArray) {
                        if ([squareLabel.name isEqualToString:name]) {
                            [self.squareLabelArray removeObject:squareLabel];
                            break;
                        }
                    }
                    return NO;
                    
                }
            }
        }
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.emojiButton setSelected:NO];
    if (self.emojiPicker.showing) {
        [self.emojiPicker hide];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger length = textView.text.length;
    NSInteger left = [self maxLetter] - length;
    [_letterNumLabel setText:[NSString stringWithFormat:@"%@",@(left)]];
}

#pragma mark- tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [ZXImagePickCell heightByImageArray:self.imageArray];
    } else {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        __weak __typeof(&*self)weakSelf = self;
        ZXImagePickCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXImagePickCell"];
        [cell setImageArray:self.imageArray];
        cell.clickBlock = ^(NSIndexPath *indexPath) {
            [weakSelf.view endEditing:YES];
            [self.emojiButton setSelected:NO];
            if (self.emojiPicker.showing) {
                [self.emojiPicker hide];
            }
            if (indexPath.row == self.imageArray.count) {
                [weakSelf showActionSheet];
            } else {
                [weakSelf showDeleteActionSheet:indexPath.row];
            }
        };
        return cell;
    } else {
        ZXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZXMenuCell"];
        [self confiureCell:cell];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self selectCellWithIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)confiureCell:(ZXMenuCell *)cell
{
    
}

- (void)selectCellWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.emojiButton.selected) {
        [self.emojiButton setSelected:NO];
        if ([self.emojiPicker showing]) {
            [self.emojiPicker hide];
        }
    }
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                {
                    // 相机
                    NSString *mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机权限受限" message:@"请去设置->隐私->相机里修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        return;
                    }
                    
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    
                    imagePickerController.delegate = self;
                    
                    imagePickerController.allowsEditing = NO;
                    
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self presentViewController:imagePickerController animated:YES completion:^{}];
                }
                    break;
                case 1:
                {
                    // 相册
                    [self showAssets];
                }
                    break;
                    
                case 2:
                    // 取消
                    return;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                [self showAssets];
            } else {
                return;
            }
        }
        
    } else {
        if (buttonIndex == 0) {
            [self.imageArray removeObjectAtIndex:actionSheet.tag];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = nil;
    //    if (self.allowEditing) {
    //        image = [info objectForKey:UIImagePickerControllerEditedImage];
    //    } else {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    }
    
    NSLog(@"imagepickerinfo = %@" , info);
    [self.imageArray addObject:image];
    [self.tableView reloadData];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark- multi pick
- (void)showAssets
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        //无权限
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相册权限受限" message:@"请去设置->隐私->照片里修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showWaiting:@"" toView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        @synchronized(_assets) {
            //        NSMutableArray *copy = [_assets copy];
            for (ALAsset *asset in _assets) {
                [photos addObject:[MWPhoto photoWithURL:asset.defaultRepresentation.url]];
//                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
//                    [thumbs addObject:[MWPhoto photoWithImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]]];
//                } else {
                    [thumbs addObject:[MWPhoto photoWithImage:[UIImage imageWithCGImage:asset.thumbnail]]];
//                }
                
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
        browser.maxSelecteNum = (9 - self.imageArray.count);
        browser.selectedNum = 0;
        [browser setCurrentPhotoIndex:0];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [hud hide:YES];
            [self presentViewController:nav animated:YES completion:nil];
        });
    });
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
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
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

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    if (_selections.count>0) {
        return [[_selections objectAtIndex:index] boolValue];
    } else {
        return NO;
    }
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    @synchronized(_assets) {
//        NSMutableArray *copy = [_assets copy];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i < _selections.count; i++) {
            NSNumber *number = _selections[i];
            if (number.boolValue) {
                ALAsset *asset = _assets[i];
//                [array addObject:[UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage]];
                [array addObject:[[UIImage alloc] initWithCGImage:[asset defaultRepresentation].fullScreenImage]];
            }
        }
        [self.imageArray addObjectsFromArray:array];
        _selections = [[NSMutableArray alloc] init];
        for (int i = 0; i < _assets.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - location
- (void)locationAction
{
    //    [BMKLocationServicesetLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    //    [BMKLocationServicesetLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    //启动LocationService
    [locService startUserLocationService];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [locService stopUserLocationService];
    self.lat = userLocation.location.coordinate.latitude;
    self.lng = userLocation.location.coordinate.longitude;
    
}

#pragma mark- setters and getters
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSMutableArray *)squareLabelArray
{
    if (!_squareLabelArray) {
        _squareLabelArray = [[NSMutableArray alloc] init];
    }
    return _squareLabelArray;
}

- (NSInteger)maxLetter
{
    return 2000;
}

- (void)dealloc
{
    self.imageArray = nil;
    self.assets = nil;
    self.assetLibrary = nil;
    self.photos = nil;
    self.thumbs = nil;
}
@end

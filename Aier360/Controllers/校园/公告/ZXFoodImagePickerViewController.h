//
//  ZXFoodImagePickerViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/27.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MWPhotoBrowser.h"

@interface ZXFoodImagePickerViewController : ZXBaseViewController<MWPhotoBrowserDelegate>
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
@property (nonatomic , copy) void (^pickBlock)(NSArray *array);
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *heightConstraint;
- (void)showOnViewControlelr:(UIViewController *)viewController;
@end

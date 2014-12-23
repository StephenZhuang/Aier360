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

@property (nonatomic , copy) void (^pickBlock)(NSArray *array);
- (void)showOnViewControlelr:(UIViewController *)viewController;
@end

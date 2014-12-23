//
//  ZXFoodListViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/25.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MWPhotoBrowser.h"

@class MWPhotoBrowser;

@interface ZXFoodListViewController : ZXRefreshTableViewController<MWPhotoBrowserDelegate>
{
    NSInteger dailyFoodState;
}

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *topAlign;
@property (nonatomic , weak) IBOutlet UIButton *releasedButton;
@property (nonatomic , weak) IBOutlet UIButton *unreleasedButton;
@property (nonatomic , weak) IBOutlet UIView *slidView;
@end

//
//  UIViewController+ZXPhotoBrowser.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/22.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface UIViewController (ZXPhotoBrowser)<MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *photos;

- (void)browseImage:(NSArray *)imageArray type:(ZXImageType)type index:(NSInteger)index;
@end

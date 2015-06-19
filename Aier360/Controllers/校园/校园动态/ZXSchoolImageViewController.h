//
//  ZXSchoolImageViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/19.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshCollectionViewController.h"
#import "MWPhotoBrowser.h"

@interface ZXSchoolImageViewController : ZXRefreshCollectionViewController<UICollectionViewDelegate ,UICollectionViewDataSource,MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic , strong) MWPhotoBrowser *browser;
@end

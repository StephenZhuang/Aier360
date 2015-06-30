//
//  ZXFavourListViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshCollectionViewController.h"

@interface ZXFavourListViewController : ZXRefreshCollectionViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , assign) long did;
@end

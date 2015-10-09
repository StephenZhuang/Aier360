//
//  ZXSquareDynamicsViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/24.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshCollectionViewController.h"
#import "ZXSquareLabel+ZXclient.h"

@interface ZXSquareDynamicsViewController : ZXRefreshCollectionViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , assign) NSInteger oslid;
@property (nonatomic , strong) ZXSquareLabel *squareLabel;
@end

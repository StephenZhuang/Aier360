//
//  ZXClassHistoryViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/2.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXDropTitleView.h"
#import "ZXClass+ZXclient.h"

@interface ZXClassHistoryViewController : ZXRefreshTableViewController<UICollectionViewDelegate , UICollectionViewDataSource> {
    UIView *mask;
}
@property (nonatomic , copy) NSString *dateString;
@property (nonatomic , weak) IBOutlet UIButton *todayButton;
@property (nonatomic , weak) IBOutlet ZXDropTitleView *classButton;
@property (nonatomic , weak) IBOutlet ZXDropTitleView *dateButton;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *classArray;
@property (nonatomic , strong) ZXClass *currentClass;
@end

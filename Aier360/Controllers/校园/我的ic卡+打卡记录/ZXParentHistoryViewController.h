//
//  ZXParentHistoryViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/3.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXDropTitleView.h"

@interface ZXParentHistoryViewController : ZXRefreshTableViewController {
    UIView *mask;
}
@property (nonatomic , copy) NSString *dateString;
@property (nonatomic , weak) IBOutlet UIButton *todayButton;
@property (nonatomic , weak) IBOutlet ZXDropTitleView *babyButton;
@property (nonatomic , weak) IBOutlet ZXDropTitleView *dateButton;
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *classArray;
@property (nonatomic , strong) ZXClass *currentClass;

@end

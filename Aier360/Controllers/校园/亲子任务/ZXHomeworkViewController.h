//
//  ZXHomeworkViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXDropTitleView.h"

@interface ZXHomeworkViewController : ZXRefreshTableViewController {
    ZXDropTitleView *dropTitle;
    NSInteger cid;
    UIView *mask;
}
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *classArray;
@property (nonatomic , strong) ZXClass *currentClass;
@end

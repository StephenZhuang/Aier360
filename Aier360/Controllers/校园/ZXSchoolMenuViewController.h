//
//  ZXSchoolMenuViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXSchoolMenuViewController : ZXBaseViewController<EMChatManagerDelegate,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL hasNewDynamic;
}
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , assign) ZXIdentity identity;

@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@end

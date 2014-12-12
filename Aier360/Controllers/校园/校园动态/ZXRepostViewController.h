//
//  ZXRepostViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXAddMailViewController.h"
#import "ZXDynamic+ZXclient.h"

@interface ZXRepostViewController : ZXAddMailViewController
@property (nonatomic , strong) ZXDynamic *dynamic;
@property (nonatomic , assign) ZXDynamicListType type;
@end

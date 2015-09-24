//
//  ZXReleaseMyDynamicViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/25.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXReleaseDynamicViewController.h"
#import "ZXPersonalDynamic+ZXclient.h"

@interface ZXReleaseMyDynamicViewController : ZXReleaseDynamicViewController
@property (nonatomic , assign) BOOL isRepost;
@property (nonatomic , strong) ZXPersonalDynamic *dynamic;
@property (nonatomic , strong) NSArray *imageNames;
@end

//
//  ZXDiscoveryViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "TopBarView.h"

@interface ZXDiscoveryViewController : ZXBaseViewController<TopBarViewDelegate,TopBarViewDataSource,UINavigationControllerDelegate>
@property (nonatomic , weak) IBOutlet TopBarView *topBarView;
@property (nonatomic , weak) IBOutlet UIView *contentView;
@end

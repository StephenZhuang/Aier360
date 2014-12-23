//
//  ZXSchoolInfoViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/14.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "TopBarView.h"

@interface ZXSchoolInfoViewController : ZXBaseViewController<TopBarViewDelegate ,TopBarViewDataSource>
@property (nonatomic , strong) ZXSchool *school;

@end

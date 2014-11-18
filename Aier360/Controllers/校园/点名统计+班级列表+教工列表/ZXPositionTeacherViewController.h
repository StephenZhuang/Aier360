//
//  ZXPositionTeacherViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXPosition.h"

@interface ZXPositionTeacherViewController : ZXRefreshTableViewController<UIActionSheetDelegate>
@property (nonatomic , strong) ZXPosition *position;
@end

//
//  ZXClassDynamicViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/15.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXClassDynamicViewController : ZXRefreshTableViewController
/**
 *  type 2:班级 3：好友
 */
@property (nonatomic , assign) NSInteger type;
@end

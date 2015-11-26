//
//  ZXBaseViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+ZXTableViewLine.h"
#import "RDVTabBarController.h"

#define HEADER_TITLE_COLOR ([UIColor colorWithRed:179 green:176 blue:168])
#define HEADER_BG_COLOR ([UIColor colorWithRed:244 green:243 blue:238])

@interface ZXBaseViewController : UIViewController
/**
 *  sb初始化，要用必须重写
 *
 *  @return self
 */
+ (instancetype)viewControllerFromStoryboard;
@end

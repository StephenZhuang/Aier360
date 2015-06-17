//
//  ZXProfileViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXBaseViewController.h"

@interface ZXProfileViewController : UITableViewController
@property (nonatomic , weak) IBOutlet UIImageView *profileImage;
+ (instancetype)viewControllerFromStoryboard;
@end

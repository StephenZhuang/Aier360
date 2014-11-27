//
//  ZXFoodImagePickerViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/27.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXFoodImagePickerViewController : ZXBaseViewController
@property (nonatomic , weak) IBOutlet UIView *maskView;
@property (nonatomic , weak) IBOutlet UIView *pickView;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , weak) IBOutlet UITableView *tableView;
- (void)showOnViewControlelr:(UIViewController *)viewController;
@end

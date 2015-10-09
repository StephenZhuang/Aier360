//
//  ZXSelectSquareLabelViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/23.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXSquareLabel+CoreDataProperties.h"

@interface ZXSelectSquareLabelViewController : ZXRefreshTableViewController
{
    UIButton *submitButton;
}
@property (nonatomic , copy) NSString *oslids;
@property (nonatomic , strong) NSMutableArray *selectedArray;
@property (nonatomic , copy) void (^selectSquareLabelBlock)(NSMutableArray *squareLabelArray);
@end

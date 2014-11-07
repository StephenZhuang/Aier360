//
//  UITableView+ZXTableViewLine.m
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/7.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "UITableView+ZXTableViewLine.h"

@implementation UITableView (ZXTableViewLine)

- (void)setExtrueLineHidden
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [self setTableFooterView:view];
}

@end

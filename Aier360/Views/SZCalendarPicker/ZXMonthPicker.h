//
//  ZXMonthPicker.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXMonthPicker : UIView
@property (nonatomic , assign) NSInteger month;
@property (nonatomic , assign) NSInteger year;
@property (nonatomic , assign) NSInteger currentYear;
@property (nonatomic, copy) void(^mobthBlock)(NSInteger month, NSInteger year);

+ (instancetype)showOnView:(UIView *)view;
+ (void)callHide;
@end

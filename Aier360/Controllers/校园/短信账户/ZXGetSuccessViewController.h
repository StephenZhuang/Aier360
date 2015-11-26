//
//  ZXGetSuccessViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/16.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXBaseViewController.h"

@interface ZXGetSuccessViewController : ZXBaseViewController
@property (nonatomic , weak) IBOutlet UILabel *reawrdLabel;
@property (nonatomic , weak) IBOutlet UIView *maskView;

@property (nonatomic , copy) NSString *reawrd;

@property (nonatomic , copy) void (^dissmissBlock)();
@end

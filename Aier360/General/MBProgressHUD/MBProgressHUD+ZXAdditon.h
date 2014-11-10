//
//  MBProgressHUD+ZXAdditon.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZXAdditon)
+ (void)showSuccess:(NSString *)text;
+ (void)showError:(NSString *)text;
+ (void)showText:(NSString *)text;

+ (instancetype)showWaiting:(NSString *)text;
- (void)turnToSuccess:(NSString *)text;
- (void)turnToError:(NSString *)text;
@end

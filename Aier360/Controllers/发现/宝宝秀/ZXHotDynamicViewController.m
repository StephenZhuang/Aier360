//
//  ZXHotDynamicViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXHotDynamicViewController.h"

@implementation ZXHotDynamicViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXHotDynamicViewController"];
}
@end

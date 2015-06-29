//
//  ZXBlankSchoolViewController.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/29.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBlankSchoolViewController.h"
#import "ZXBigImageViewController.h"

@implementation ZXBlankSchoolViewController
+ (instancetype)viewControllerFromStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SchoolInfo" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:@"ZXBlankSchoolViewController"];
}

@end

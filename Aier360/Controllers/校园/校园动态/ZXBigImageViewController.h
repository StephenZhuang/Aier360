//
//  ZXBigImageViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/29.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXBigImageViewController : ZXBaseViewController
@property (nonatomic , copy) NSString *imageName;
@property (nonatomic , weak) IBOutlet UIImageView *imageView;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *imageHeight;
@end

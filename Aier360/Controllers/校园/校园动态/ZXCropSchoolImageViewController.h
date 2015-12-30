//
//  ZXCropSchoolImageViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/29.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXCropSchoolImageViewController : ZXBaseViewController
@property (nonatomic , weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic , weak) IBOutlet UIImageView *imageView;
@property (nonatomic , weak) IBOutlet UIButton *smallButton;
@property (nonatomic , weak) IBOutlet UIButton *bigButton;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *imageHeight;

@property (nonatomic , copy) NSString *imageUrl;

@property (nonatomic , strong) CALayer *alphaLayer;
@property (nonatomic , strong) CAShapeLayer *shapeLayer;
@property (nonatomic , assign) BOOL big;
@end

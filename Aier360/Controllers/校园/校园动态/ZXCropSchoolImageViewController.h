//
//  ZXCropSchoolImageViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/29.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@class ZXCropImageView;

@interface ZXCropSchoolImageViewController : ZXBaseViewController

@property (nonatomic , weak) IBOutlet UIButton *smallButton;
@property (nonatomic , weak) IBOutlet UIButton *bigButton;

@property (nonatomic , copy) NSString *imageUrl;

@property (nonatomic , strong) CALayer *alphaLayer;
@property (nonatomic , strong) CAShapeLayer *shapeLayer;
@property (nonatomic , assign) BOOL big;

@property (nonatomic , weak) IBOutlet UIView *contentView;
@property (nonatomic , strong) ZXCropImageView *smallImageView;
@property (nonatomic , strong) ZXCropImageView *bigImageView;
@end

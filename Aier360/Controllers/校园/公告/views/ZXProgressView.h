//
//  ZXProgressView.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/13.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXProgressView : UIView
@property (nonatomic , strong) UIImage *progressImage;
@property (nonatomic , strong) UIImage *trackImage;
@property(nonatomic) float progress;

@property (nonatomic, strong) UIImageView *trackImageView;
@property (nonatomic, strong) UIImageView *progressImageView;

- (void)setProgress:(float)progress animated:(BOOL)animated;
@end

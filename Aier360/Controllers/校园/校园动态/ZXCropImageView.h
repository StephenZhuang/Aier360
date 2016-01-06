//
//  ZXCropImageView.h
//  Aierbon
//
//  Created by Stephen Zhuang on 16/1/6.
//  Copyright © 2016年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXCropImageView : UIView<UIScrollViewDelegate>
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , assign) CGFloat cropHeight;

- (instancetype)initWithImageUrl:(NSString *)imageUrl;
@end

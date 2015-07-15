//
//  ZXBlankView.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/7/15.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXBlankView : UIView
@property (nonatomic , weak) IBOutlet UIImageView *imageView;
@property (nonatomic , weak) IBOutlet UILabel *label;
- (void)configureWithImage:(UIImage *)image text:(NSString *)text;
@end

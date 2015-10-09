//
//  ZXSqualeDetailView.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/28.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXSqualeDetailView.h"

@implementation ZXSqualeDetailView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.imageView.layer.masksToBounds = YES;
}
@end

//
//  ZXQrcodeView.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/31.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXQrcodeView : UIView
{
    @private
    BOOL canHide;
}
@property (nonatomic , strong) UIView *maskView;
@property (nonatomic , strong) UIView *contentView;
@property (nonatomic , copy) NSString *pickTitle;
@property (nonatomic , copy) void (^ZXPopPickerBlock)(NSInteger selectedIndex);

@end

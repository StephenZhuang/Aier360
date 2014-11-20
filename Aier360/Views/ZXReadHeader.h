//
//  ZXReadHeader.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZXReadHeaderState) {
    ZXReadHeaderStateOn = 0,
    ZXReadHeaderStateOff = 1
};

@interface ZXReadHeader : UIView
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet UIImageView *arrowImage;
@property (nonatomic , assign) ZXReadHeaderState state;
@property (nonatomic , copy) void (^toggleBlock)(ZXReadHeaderState state);
@end

//
//  ZXMenuCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXBaseCell.h"

@interface ZXMenuCell : ZXBaseCell
@property (nonatomic , weak) IBOutlet UILabel *hasNewLabel;
@property (nonatomic , weak) IBOutlet UIImageView *itemImage;
@end

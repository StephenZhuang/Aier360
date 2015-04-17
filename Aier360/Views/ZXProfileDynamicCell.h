//
//  ZXProfileDynamicCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/17.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"

@interface ZXProfileDynamicCell : ZXBaseCell
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
@property (nonatomic , weak) IBOutlet UILabel *numLabel;
@end

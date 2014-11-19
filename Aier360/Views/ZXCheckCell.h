//
//  ZXCheckCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"

@interface ZXCheckCell : ZXBaseCell
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet UIButton *rejectButton;
@property (nonatomic , weak) IBOutlet UIButton *agreeButton;
@end

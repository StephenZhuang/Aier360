//
//  ZXContactsCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 14/12/29.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"

@interface ZXContactsCell : ZXBaseCell
@property (nonatomic , weak) IBOutlet UIButton *refuseButton;
@property (nonatomic , weak) IBOutlet UILabel *addressLabel;
@property (nonatomic , weak) IBOutlet UIButton *agreeButton;
@property (nonatomic , weak) IBOutlet UILabel *tagLabel;
@end

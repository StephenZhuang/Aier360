//
//  ZXContactsCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 14/12/29.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"
#import "ZXFollow.h"

@interface ZXContactsCell : ZXBaseCell
@property (nonatomic , weak) IBOutlet UIButton *ageButton;
@property (nonatomic , weak) IBOutlet UILabel *addressLabel;
@property (nonatomic , weak) IBOutlet UIButton *focusButton;
- (void)configreUIWithFollow:(ZXFollow *)follow;
@end

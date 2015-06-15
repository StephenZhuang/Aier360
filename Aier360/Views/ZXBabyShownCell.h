//
//  ZXBabyShownCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/21.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"
#import "ZXBaby.h"

@interface ZXBabyShownCell : ZXBaseCell
@property (nonatomic , strong) NSArray *babyList;

@property (nonatomic , strong) UIView *babyItemContentView;
@end

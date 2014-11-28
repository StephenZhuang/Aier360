//
//  ZXAddFoodCell.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/28.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"

@interface ZXAddFoodCell : ZXBaseCell
@property (nonatomic , weak) IBOutlet UITextField *titleTextField;
@property (nonatomic , weak) IBOutlet UITextField *contentTextField;
@property (nonatomic , weak) IBOutlet UIButton *deleteButton;
@end

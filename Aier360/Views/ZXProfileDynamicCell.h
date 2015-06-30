//
//  ZXProfileDynamicCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/17.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseCell.h"
#import "MLEmojiLabel+ZXAddition.h"

@interface ZXProfileDynamicCell : ZXBaseCell<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *tipLabel;
@property (nonatomic , weak) IBOutlet UILabel *numLabel;
@end

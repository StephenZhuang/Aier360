//
//  ZXPersonalDynamicCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/9.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel+ZXAddition.h"

@interface ZXPersonalDynamicCell : UITableViewCell<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *repostLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *contentLabel;
@property (nonatomic , weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic , weak) IBOutlet UILabel *imgNumLabel;
@property (nonatomic , weak) IBOutlet UIView *repostBackground;
@end

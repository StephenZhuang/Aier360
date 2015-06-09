//
//  ZXPersonalDynamicCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/9.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXPersonalDynamicCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet UILabel *repostLabel;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet UIImageView *logoImageView;
@property (nonatomic , weak) IBOutlet UILabel *imgNumLabel;
@property (nonatomic , weak) IBOutlet UIView *repostBackground;
@end

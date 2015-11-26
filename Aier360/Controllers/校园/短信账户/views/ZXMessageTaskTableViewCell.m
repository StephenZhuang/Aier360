//
//  ZXMessageTaskTableViewCell.m
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/16.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXMessageTaskTableViewCell.h"

@implementation ZXMessageTaskTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.squareView.layer.borderColor = [UIColor colorWithRed:246/255.0 green:202/255.0 blue:174/255.0 alpha:1.0].CGColor;
    self.squareView.layer.borderWidth = 1;
    
    [self.progressView setProgressImage:[[UIImage imageNamed:@"ma_progress_progress"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 3, 4, 3)]];
    [self.progressView setTrackImage:[UIImage imageNamed:@"ma_progress_track"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureUIWithMessageTask:(ZXMessageTask *)messageTask
{
    float progress = messageTask.dynamicActual * 1.0 / messageTask.dynamicExpect;
    [self.progressView setProgress:progress animated:YES];
    
    [self.progressLabel setText:[NSString stringWithFormat:@"%@/%@",@(MIN(messageTask.dynamicActual, messageTask.dynamicExpect)),@(messageTask.dynamicExpect)]];
    [self.messageNumLabel setText:messageTask.rewardStr];
    [self.taskLabel setText:messageTask.mtContent];
    
    if (messageTask.complete == 0) {
        [self.getButton setHidden:NO];
        [self.gotLabel setHidden:YES];
        if (progress >= 1) {
            self.getButton.enabled = YES;
        } else {
            self.getButton.enabled = NO;
        }
    } else {
        [self.getButton setHidden:YES];
        [self.gotLabel setHidden:NO];
    }
}
@end

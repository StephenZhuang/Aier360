//
//  ZXSensitiveDynamicTableViewCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/15.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXDynamicComment.h"
#import "ZXPersonalDynamic.h"
#import "MLEmojiLabel+ZXAddition.h"
#import "ZXManagedUser.h"
#import <SWTableViewCell/SWTableViewCell.h>

@interface ZXSensitiveDynamicTableViewCell : SWTableViewCell<MLEmojiLabelDelegate>
@property (nonatomic , weak) IBOutlet UIImageView *headImg;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *classLabel;
@property (nonatomic , weak) IBOutlet UILabel *timeLabel;
@property (nonatomic , weak) IBOutlet MLEmojiLabel *contentLabel;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *contentHeight;

- (void)configureCellWithDynamic:(ZXPersonalDynamic *)dynamic;
- (void)configureCellWithComment:(ZXDynamicComment *)comment;
@end

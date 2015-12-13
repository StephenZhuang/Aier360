//
//  ZXICCardTableViewCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/13.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXICCard.h"

@interface ZXICCardTableViewCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UIImageView *bgImage;
@property (nonatomic , weak) IBOutlet UIButton *actionButton;
@property (nonatomic , weak) IBOutlet UILabel *cardNumLabel;
@property (nonatomic , weak) IBOutlet UILabel *cardNumTitleLabel;
@property (nonatomic , weak) IBOutlet UILabel *codeLabel;
@property (nonatomic , weak) IBOutlet UILabel *codeTitleLabel;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *nameTitleLabel;
@property (nonatomic , weak) IBOutlet UILabel *jobLabel;
@property (nonatomic , weak) IBOutlet UILabel *jobTitleLabel;
@property (nonatomic , weak) IBOutlet UILabel *schoolLabel;
@property (nonatomic , weak) IBOutlet UILabel *schoolTitleLabel;

- (void)configureCellWithCard:(ZXICCard *)card;
@end

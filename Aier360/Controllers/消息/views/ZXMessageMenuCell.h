//
//  ZXMessageMenuCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/8.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXMessageMenuCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic , weak) IBOutlet UILabel *badgeLabel;
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , assign) NSInteger messageNum;
@end

//
//  ZXSchoolMenuCollectionViewCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/6.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXSchoolMenuCollectionViewCell : UICollectionViewCell
@property (nonatomic , weak) IBOutlet UIImageView *iconImage;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UIView *virticalLine;
@property (nonatomic , weak) IBOutlet UIView *horizonLine;
@property (nonatomic , weak) IBOutlet UIView *badgeView;
@property (nonatomic , weak) IBOutlet UIImageView *messageAccountTip;
@end

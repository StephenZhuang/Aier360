//
//  ZXClassFilterTableViewCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/10.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXClass.h"

@interface ZXClassFilterTableViewCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , weak) IBOutlet UILabel *imageLabel;
@property (nonatomic , weak) IBOutlet UIImageView *imageIcon;
@property (nonatomic , weak) IBOutlet UILabel *favLabel;
@property (nonatomic , weak) IBOutlet UIImageView *favIcon;

- (void)configureCellWithClass:(ZXClass *)zxclass;
@end

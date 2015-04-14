//
//  ZXMyProfileViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/14.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXMyProfileViewController : UITableViewController
@property (nonatomic , weak) IBOutlet UIImageView *profileImage;
@property (nonatomic , weak) IBOutlet UIButton *headButton;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@end

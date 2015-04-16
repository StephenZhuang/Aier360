//
//  ZXMyProfileViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/14.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXProfileViewController.h"

@interface ZXMyProfileViewController : ZXProfileViewController

@property (nonatomic , weak) IBOutlet UIButton *headButton;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , strong) UIView *bottomView;
@property (nonatomic , strong) ZXUser *user;
@end

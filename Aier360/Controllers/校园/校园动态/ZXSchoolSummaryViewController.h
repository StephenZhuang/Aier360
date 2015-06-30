//
//  ZXSchoolSummaryViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/4.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXSchool+ZXclient.h"

@interface ZXSchoolSummaryViewController : ZXBaseViewController
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *infoLabel;
@property (nonatomic , weak) IBOutlet UIButton *telButton;
@property (nonatomic , weak) IBOutlet UILabel *addressLabel;
@end

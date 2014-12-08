//
//  ZXTeacherGracefulDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/8.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXTeacherCharisma.h"

@interface ZXTeacherGracefulDetailViewController : ZXBaseViewController
@property (nonatomic , strong) ZXTeacherCharisma *teacher;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic , weak) IBOutlet UILabel *contentLabel;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *imageHeight;
@end

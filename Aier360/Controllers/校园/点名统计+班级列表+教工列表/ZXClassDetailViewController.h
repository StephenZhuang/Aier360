//
//  ZXClassDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXClassDetailViewController : ZXBaseViewController
@property (nonatomic , assign) NSInteger cid;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UILabel *numLabel;
@property (nonatomic , weak) IBOutlet UILabel *masterLabel;
@property (nonatomic , weak) IBOutlet UILabel *assistLabel;
@property (nonatomic , weak) IBOutlet UILabel *careLabel;
@end

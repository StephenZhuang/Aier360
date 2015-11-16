//
//  ZXMessageTaskTableViewCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/16.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXProgressView.h"
#import "ZXMessageTask.h"

@interface ZXMessageTaskTableViewCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UIView *squareView;
@property (nonatomic , weak) IBOutlet UILabel *messageNumLabel;
@property (nonatomic , weak) IBOutlet UILabel *taskLabel;
@property (nonatomic , weak) IBOutlet ZXProgressView *progressView;
@property (nonatomic , weak) IBOutlet UIButton *getButton;
@property (nonatomic , weak) IBOutlet UILabel *gotLabel;
@property (nonatomic , weak) IBOutlet UILabel *progressLabel;

- (void)configureUIWithMessageTask:(ZXMessageTask *)messageTask;
@end

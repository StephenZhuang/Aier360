//
//  ZXUnactiveTeacherViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/17.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXUnactiveTeacherViewController : ZXRefreshTableViewController
@property (nonatomic , assign) BOOL hasSentMessage;
@property (nonatomic , copy) NSString *messageStr;
@property (nonatomic , weak) IBOutlet UILabel *headerLabel;
@end

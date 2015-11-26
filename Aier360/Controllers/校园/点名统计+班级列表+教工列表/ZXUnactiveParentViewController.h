//
//  ZXUnactiveParentViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/17.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXUnactiveParentViewController : ZXRefreshTableViewController
@property (nonatomic , assign) BOOL hasSentMessage;
@property (nonatomic , copy) NSString *messageStr;
@property (nonatomic , weak) IBOutlet UILabel *headerLabel;
@property (nonatomic , assign) long cid;
@end

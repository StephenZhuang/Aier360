//
//  ZXParentDynamicViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/15.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXParentDynamicViewController : ZXRefreshTableViewController
{
    BOOL hasCache;
    NSInteger unreadMessageNum;
}
@property (nonatomic , weak) IBOutlet UIButton *circleButton;
@property (nonatomic , weak) IBOutlet UIButton *messageButton;
@property (nonatomic , weak) IBOutlet UIView *messageView;
@property (nonatomic , weak) IBOutlet UILabel *unreadMessageLabel;
@end

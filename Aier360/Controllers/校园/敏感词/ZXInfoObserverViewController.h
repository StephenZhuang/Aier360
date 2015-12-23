//
//  ZXInfoObserverViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/12/15.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"

@interface ZXInfoObserverViewController : ZXRefreshTableViewController
@property (nonatomic , assign) NSInteger selectedIndex;
@property (nonatomic , weak) IBOutlet UIButton *dynamicButton;
@property (nonatomic , weak) IBOutlet UIButton *commentButton;
@property (nonatomic , weak) IBOutlet NSLayoutConstraint *leftMargin;
@end

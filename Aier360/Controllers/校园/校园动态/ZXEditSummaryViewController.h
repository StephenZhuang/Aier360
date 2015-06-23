//
//  ZXEditSummaryViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/18.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "UIPlaceHolderTextView.h"

@interface ZXEditSummaryViewController : ZXBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) ZXSchool *school;
@property (nonatomic , weak) IBOutlet UIPlaceHolderTextView *textView;
@end

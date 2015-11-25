//
//  ZXMessageRecordDetailViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/25.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXMessageRecord.h"

@interface ZXMessageRecordDetailViewController : ZXBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) ZXMessageRecord *messageRecord;
@property (nonatomic , weak) IBOutlet UILabel *moneyLabel;
@property (nonatomic , weak) IBOutlet UILabel *numLabel;
@property (nonatomic , weak) IBOutlet UILabel *stateLabel;
@end

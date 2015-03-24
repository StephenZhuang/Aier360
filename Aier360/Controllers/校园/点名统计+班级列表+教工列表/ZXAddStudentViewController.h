//
//  ZXAddStudentViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/3/18.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@class ZXStudentTemp;

@interface ZXStudentTemp : NSObject
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *sex;
@end

@interface ZXAddStudentViewController : ZXBaseViewController<UITableViewDelegate ,UITableViewDataSource , UIActionSheetDelegate>
@property (nonatomic , strong) ZXClass *zxclass;
@end

//
//  ZXCardDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/24.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXICCard+ZXclient.h"

@interface ZXCardDetailViewController : ZXBaseViewController<UIAlertViewDelegate>
@property (nonatomic , strong) ZXICCard *card;
@property (nonatomic , copy) NSString *cardNum;

@property (nonatomic , copy) void (^lossReportBlock)();
@end

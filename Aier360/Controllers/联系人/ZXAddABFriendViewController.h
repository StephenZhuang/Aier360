//
//  ZXAddABFriendViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/3.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "MBProgressHUD+ZXAdditon.h"
#import <MessageUI/MessageUI.h>

@class ZXPersonTemp;

@interface ZXPersonTemp : NSObject
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *name;
@end

@interface ZXAddABFriendViewController : ZXBaseViewController<UITableViewDelegate , UITableViewDataSource , MFMessageComposeViewControllerDelegate>
{
    MBProgressHUD *hud;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *addressBookArray;
@property (nonatomic , strong) NSMutableArray *registedArray;
@end

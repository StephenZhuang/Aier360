//
//  ZXMyDynamicViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/16.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXUser+ZXclient.h"

@interface ZXMyDynamicViewController : ZXRefreshTableViewController<UIActionSheetDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
@property (nonatomic , strong) ZXUser *user;
@property (nonatomic , copy) void (^changeLogoBlock)();

@end

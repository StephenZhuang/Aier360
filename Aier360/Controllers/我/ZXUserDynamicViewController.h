//
//  ZXUserDynamicViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXUser+ZXclient.h"

@interface ZXUserDynamicViewController : ZXRefreshTableViewController<UIActionSheetDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
@property (nonatomic , strong) ZXUser *user;
@property (nonatomic , assign) NSInteger uid;
@end

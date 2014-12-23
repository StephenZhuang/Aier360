//
//  ZXSchoolDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/4.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXSchool+ZXclient.h"

@interface ZXSchoolDetailViewController : ZXRefreshTableViewController<UIActionSheetDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
@property (nonatomic , strong) ZXSchool *school;
@property (nonatomic , strong) ZXSchoolDetail *schoolDetail;

@property (nonatomic , copy) void (^changeLogoBlock)();
@end

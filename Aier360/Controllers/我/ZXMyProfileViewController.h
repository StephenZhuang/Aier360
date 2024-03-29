//
//  ZXMyProfileViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/4/14.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXProfileViewController.h"
#import "ZXDynamic.h"

@interface ZXMyProfileViewController : ZXProfileViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic , weak) IBOutlet UIButton *headButton;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , strong) ZXUser *user;
@property (nonatomic , strong) ZXDynamic *dynamic;
@property (nonatomic , assign) NSInteger dynamicCount;
@property (nonatomic , strong) NSArray *babyList;
@property (nonatomic , copy) void (^changeLogoBlock)();
@end

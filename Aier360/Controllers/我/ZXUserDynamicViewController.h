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

@property (nonatomic , weak) IBOutlet UIImageView *logoImage;
@property (nonatomic , weak) IBOutlet UIImageView *sexImage;
@property (nonatomic , weak) IBOutlet UILabel *memberLabel;
@property (nonatomic , weak) IBOutlet UILabel *reloationLabel;
@property (nonatomic , weak) IBOutlet UIButton *focusButton;
@property (nonatomic , weak) IBOutlet UIButton *chatButton;
@property (nonatomic , strong) IBOutlet NSLayoutConstraint *buttonSpace;
@property (nonatomic , strong) NSLayoutConstraint *buttonAlign;

@property (nonatomic , assign) NSInteger uid;
@end

//
//  ZXReleaseDynamicViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/20.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MWPhotoBrowser.h"
#import "UIPlaceHolderTextView.h"

@interface ZXReleaseDynamicViewController : ZXBaseViewController<UITextViewDelegate , UITextFieldDelegate ,UITableViewDelegate ,UITableViewDataSource ,UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate,MWPhotoBrowserDelegate>
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , weak) IBOutlet UIPlaceHolderTextView *contentTextView;
@property (nonatomic , weak) IBOutlet UIButton *emojiButton;
@property (nonatomic , weak) IBOutlet UIButton *squareLabelButton;
@property (nonatomic , assign) NSInteger maxLetter;
@property (nonatomic , assign) float lat;
@property (nonatomic , assign) float lng;
@property (nonatomic , copy) NSString *address;

@property (nonatomic , strong) NSMutableArray *squareLabelArray;
@property (nonatomic , copy) void (^addSuccess)();

- (void)releaseAction;
@end

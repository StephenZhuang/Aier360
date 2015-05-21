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

@interface ZXReleaseDynamicViewController : ZXBaseViewController<UITextViewDelegate , UITextFieldDelegate ,UITableViewDelegate ,UITableViewDataSource ,UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate,MWPhotoBrowserDelegate>

@end

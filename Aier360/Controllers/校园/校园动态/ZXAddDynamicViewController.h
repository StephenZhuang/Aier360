//
//  ZXAddDynamicViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/12.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "UIPlaceHolderTextView.h"
#import "MBProgressHUD+ZXAdditon.h"
#import "ZXEmojiPicker.h"

@interface ZXAddDynamicViewController : ZXBaseViewController<UITextViewDelegate , UITextFieldDelegate ,UITableViewDelegate ,UITableViewDataSource ,UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate>

/**
 *  动态类型(1学校动态2班级动态3个人动态)
 */
@property (nonatomic , assign) NSInteger type;
@end

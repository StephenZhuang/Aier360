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
{
    MBProgressHUD *hud;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , weak) IBOutlet UIPlaceHolderTextView *contentTextView;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , weak) IBOutlet ZXEmojiPicker *emojiPicker;
@property (nonatomic , weak) IBOutlet UIButton *emojiButton;

@end

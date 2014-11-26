//
//  ZXAddAnnouncementViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/18.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "UIPlaceHolderTextView.h"
#import "MBProgressHUD+ZXAdditon.h"

@interface ZXAddAnnouncementViewController : ZXBaseViewController<UITextViewDelegate , UITextFieldDelegate ,UITableViewDelegate ,UITableViewDataSource ,UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate>
{
    MBProgressHUD *hud;
    NSInteger _people;
    NSInteger _mesLeft;
    NSInteger _currentCount;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;
@property (nonatomic , weak) IBOutlet UITextField *titleTextField;
@property (nonatomic , weak) IBOutlet UIPlaceHolderTextView *contentTextView;
@property (nonatomic , weak) IBOutlet UILabel *letterNumLabel;
@property (nonatomic , copy) NSString *receiver;
@property (nonatomic , strong) NSMutableArray *receiverArray;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , strong) NSMutableArray *imageUrlArray;
@property (nonatomic , weak) IBOutlet UIButton *smsButton;
@property (nonatomic , weak) IBOutlet UILabel *tipLabel;
@end

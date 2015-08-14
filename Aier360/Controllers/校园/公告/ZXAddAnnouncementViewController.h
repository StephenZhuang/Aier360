//
//  ZXAddAnnouncementViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/7.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXAnnouncement+ZXclient.h"
#import "UIViewController+ZXPhotoBrowser.h"

@interface ZXAddAnnouncementViewController : ZXBaseViewController<UITextViewDelegate , UITextFieldDelegate ,UITableViewDelegate ,UITableViewDataSource ,UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate,MWPhotoBrowserDelegate>
{
    NSString *announcementContent;
    NSString *announcementTitle;
    NSInteger type;
    NSString *tids;
    NSString *tnames;
}
@property (nonatomic , weak) IBOutlet UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , copy) void (^addSuccess)();
@end

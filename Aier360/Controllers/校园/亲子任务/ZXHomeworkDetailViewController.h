//
//  ZXHomeworkDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/19.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXEmojiPicker.h"
#import "ZXHomework+ZXclient.h"

@interface ZXHomeworkDetailViewController : ZXRefreshTableViewController<UITextFieldDelegate>
{
    NSInteger chid;
    NSString *rname;
    NSInteger index;
}

@property (nonatomic , strong) ZXHomework *homework;
@property (nonatomic , weak) IBOutlet ZXEmojiPicker *emojiPicker;
@property (nonatomic , weak) IBOutlet UIButton *emojiButton;
@property (nonatomic , weak) IBOutlet UIButton *cameraButton;
@property (nonatomic , weak) IBOutlet UITextField *commentTextField;
@property (nonatomic , weak) IBOutlet UIView *toolView;
@property (nonatomic , copy) void (^deleteBlock)();

@property (nonatomic , strong) NSMutableArray *imageArray;
@end

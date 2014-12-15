//
//  ZXDynamicDetailViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXDynamic+ZXclient.h"
#import "ZXUser+ZXclient.h"
#import "ZXEmojiPicker.h"

@interface ZXDynamicDetailViewController : ZXRefreshTableViewController<UITextFieldDelegate>
{
    NSInteger dcid;
    NSString *rname;
}
@property (nonatomic , strong) ZXDynamic *dynamic;
@property (nonatomic , weak) IBOutlet ZXEmojiPicker *emojiPicker;
@property (nonatomic , weak) IBOutlet UIButton *emojiButton;
@property (nonatomic , weak) IBOutlet UITextField *commentTextField;
@property (nonatomic , weak) IBOutlet UIView *toolView;
@property (nonatomic , copy) void (^deleteBlock)();
@property (nonatomic , assign) NSInteger type;
@end

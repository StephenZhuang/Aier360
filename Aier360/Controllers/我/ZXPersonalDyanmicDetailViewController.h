//
//  ZXPersonalDyanmicDetailViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/10.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXRefreshTableViewController.h"
#import "ZXEmojiPicker.h"
#import "ZXCommentToolBar.h"
#import "ZXPersonalDynamic+ZXclient.h"

@interface ZXPersonalDyanmicDetailViewController : ZXRefreshTableViewController
/**
 *  个人动态不传，学校动态，家长圈传
 */
@property (nonatomic , strong) ZXPersonalDynamic *dynamic;
@property (nonatomic , assign) long did;
/**
 *  1:学校动态 2：个人动态
 */
@property (nonatomic , assign) NSInteger type;
@property (nonatomic , strong) NSMutableArray *prasedUserArray;
@property (nonatomic , weak) IBOutlet ZXCommentToolBar *commentToolBar;
@property (nonatomic , weak) IBOutlet ZXEmojiPicker *emojiPicker;
@end

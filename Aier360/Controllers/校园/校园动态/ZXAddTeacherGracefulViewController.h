//
//  ZXAddTeacherGracefulViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/5.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"
#import "ZXTeacherCharisma+ZXclient.h"

@interface ZXAddTeacherGracefulViewController : ZXBaseViewController<UITextFieldDelegate ,UIActionSheetDelegate , UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
@property (nonatomic , strong) ZXTeacherCharisma *teacher;
@property (nonatomic , copy) void (^editBlock)();
@end

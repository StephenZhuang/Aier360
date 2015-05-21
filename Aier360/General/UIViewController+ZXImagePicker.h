//
//  UIViewController+ZXImagePicker.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/5/21.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZXImagePicker)<UIActionSheetDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate>
@property (nonatomic , copy) void (^completion)(NSArray *imageArray);
- (void)showActionSheetWithCompletion:(void (^)(NSArray *imageArray))completion;
@end

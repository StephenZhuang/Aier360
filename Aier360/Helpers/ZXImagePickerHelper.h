//
//  ZXImagePickerHelper.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/20.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//TODO: actionsheet delegate无效,暂时没用，后期决定是否删除
@interface ZXImagePickerHelper : NSObject<UIActionSheetDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate>
@property (nonatomic , strong) UIViewController *delegate;
@property (nonatomic , assign) BOOL allowEditing;
@property (nonatomic , copy) void (^completion)(UIImage *image);

+ (void)showPickerWithDelegate:(UIViewController *)delegate allowEditing:(BOOL)allowEditing completion:(void(^)(UIImage *image))completion;
- (void)showActionSheet;
@end

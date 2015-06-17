//
//  ZXUserProfileViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/16.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXProfileViewController.h"
#import "ZXDynamic.h"
#import "ZXUserToolView.h"

@interface ZXUserProfileViewController : ZXProfileViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _isFriend;
}
@property (nonatomic , weak) IBOutlet UIButton *headButton;
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , strong) UIView *bottomView;
@property (nonatomic , strong) ZXUser *user;
@property (nonatomic , strong) ZXDynamic *dynamic;
@property (nonatomic , assign) NSInteger dynamicCount;
@property (nonatomic , strong) NSArray *babyList;
@property (nonatomic , strong) ZXUserToolView *userToolView;
@property (nonatomic , assign) long uid;
@property (nonatomic , copy) void (^deleteFriendBlock)();
@end

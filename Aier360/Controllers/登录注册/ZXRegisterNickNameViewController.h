//
//  ZXRegisterNickNameViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/14.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXRegisterNickNameViewController : ZXBaseViewController<UITextFieldDelegate>
@property (nonatomic , copy) NSString *phone;
@property (nonatomic , copy) NSString *password;

@end

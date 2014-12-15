//
//  ZXChangePasswordViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/12/15.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXChangePasswordViewController : ZXBaseViewController<UITextFieldDelegate>
@property (nonatomic , weak) IBOutlet UITextField *oldPasswordTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordAgainTextField;
@property (nonatomic , copy) NSString *phone;

@end

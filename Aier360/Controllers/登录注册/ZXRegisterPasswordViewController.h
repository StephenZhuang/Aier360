//
//  ZXRegisterPasswordViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/14.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXRegisterPasswordViewController : ZXBaseViewController<UITextFieldDelegate>

@property (nonatomic , weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordAgainTextField;
@property (nonatomic , copy) NSString *phone;
@end

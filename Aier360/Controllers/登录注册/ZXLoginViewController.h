//
//  ZXLoginViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/10.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXLoginViewController : ZXBaseViewController<UITextFieldDelegate>
@property (nonatomic , weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic , weak) IBOutlet UIImageView *logoImage;
@end

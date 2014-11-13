//
//  ZXRegisterViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/13.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXRegisterViewController : ZXBaseViewController<UITextFieldDelegate>
{
    UIBarButtonItem *item;
}
@property (nonatomic , assign) BOOL isRegister;
@property (nonatomic , weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic , weak) IBOutlet UITextField *verifyTextField;
@property (nonatomic , weak) IBOutlet UITextField *codeTextField;
@property (nonatomic , weak) IBOutlet UIImageView *verifyImage;
@property (nonatomic , weak) IBOutlet UIButton *getCodeButton;
@property (nonatomic , weak) IBOutlet UIButton *agreeButton;
@end

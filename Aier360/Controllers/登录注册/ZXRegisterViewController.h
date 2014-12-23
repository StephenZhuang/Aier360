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

@end

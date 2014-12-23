//
//  ZXRegisterPasswordViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/14.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXRegisterPasswordViewController : ZXBaseViewController<UITextFieldDelegate>


@property (nonatomic , copy) NSString *phone;
/**
 *  1:注册 2：忘记密码 
 */
@property (nonatomic , assign) NSInteger type;
@end

//
//  ZXCustomTextFieldViewController.h
//  Aier360
//
//  Created by Stephen Zhuang on 14/11/17.
//  Copyright (c) 2014年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

typedef void(^TextBlock)(NSString *text);

@interface ZXCustomTextFieldViewController : ZXBaseViewController<UITextFieldDelegate>
@property (nonatomic , weak) IBOutlet UITextField *textField;
@property (nonatomic , copy) NSString *text;
@property (nonatomic , copy) NSString *placeholder;
@property (nonatomic , copy) TextBlock textBlock;

@end

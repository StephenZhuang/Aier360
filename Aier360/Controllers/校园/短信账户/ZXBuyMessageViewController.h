//
//  ZXBuyMessageViewController.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/11/18.
//  Copyright © 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import "ZXBaseViewController.h"

@interface ZXBuyMessageViewController : ZXBaseViewController<UITextFieldDelegate>
@property (nonatomic , weak) IBOutlet UITextField *textField;
@property (nonatomic , weak) IBOutlet UILabel *totalPriceLabel;
@property (nonatomic , weak) IBOutlet UILabel *priceLabel;
@end

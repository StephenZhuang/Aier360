//
//  ZXTextFieldCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/6/18.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXTextFieldCell : UITableViewCell
@property (nonatomic , weak) IBOutlet UILabel *nameLabel;
@property (nonatomic , weak) IBOutlet UITextField *textField;
@end

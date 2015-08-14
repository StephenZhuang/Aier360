//
//  ZXAnnouncementTitleCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/8/12.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXAnnouncementTitleCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic , weak) IBOutlet UITextField *textField;
@property (nonatomic , weak) IBOutlet UILabel *letterLabel;
@property (nonatomic , copy) void (^textBlock)(NSString *text);
@end

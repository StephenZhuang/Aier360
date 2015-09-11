//
//  ZXReportTableViewCell.h
//  Aierbon
//
//  Created by Stephen Zhuang on 15/9/11.
//  Copyright (c) 2015年 Zhixing Internet of Things Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface ZXReportTableViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic , weak) IBOutlet UIImageView *iconImage;
@property (nonatomic , weak) IBOutlet UILabel *titleLabel;
@property (nonatomic , weak) IBOutlet UIPlaceHolderTextView *textView;
@end
